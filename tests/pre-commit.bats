#!/usr/bin/env bats

function default_test {
    run git commit -m "test"
}

function trailing_space_test {
    git commit -m "test"
    if [ "$(cat ${FILE})" = "${TEXT}" ]; then
        status=0
    else
        status=1
    fi
}

function test_via_commit {
    ##### Params #####
    BRANCH=$1
    EXIT_STATUS=$2
    FILE=${3-"test_file"}
    TEXT=${4-"${BRANCH}"}
    RUN_TEST=${5-"default_test"}
    ### Params end ###

    # Preparation
    git checkout -b ${BRANCH}

    echo "${TEXT}" > ${FILE}
    git add ${FILE}

    # Test
    $RUN_TEST

    # Cleanup
    git checkout -
    git branch -D ${BRANCH}
    git reset -- ${FILE}
    rm -rf ${FILE}

    # Check is test success
    [ "$status" -eq ${EXIT_STATUS} ]
}


@test "is git exist" {
    run git status
    [ "$status" -eq 0 ]
}


@test "FIX TEST: is work on rebase" {
    skip
    # Preparation
    git add -A
    git commit -m "Test pre-commit on rebase"
    git checkout -b test/pre-commit

    # Test
    run GIT_SEQUENCE_EDITOR="sed -i -re 's/^pick /r /'" git rebase -i HEAD~1 &

    if [ "$(ps aux | grep $(git var GIT_EDITOR) | grep COMMIT_EDITMSG)" != "" ] ; then
    # if [ "$status" == "0" ] ; then
        kill $(ps aux | grep $(git var GIT_EDITOR) | grep COMMIT_EDITMSG | awk '{print $2}')
    fi
    git rebase --abort

    # Cleanup
    git checkout -
    git branch -D test/pre-commit
    git reset HEAD^
    # Check is test success
    [ "$status" -eq 0 ]
}


@test "is all issue types exist" {
    ISSUE_TYPES=(
        feature
        improve
        fix
        test
        docs
        style
        refactor
        legacy
    )

    for TYPE in ${ISSUE_TYPES[@]}; do
        test_via_commit ${TYPE}/short_description 0
    done
}


@test "is not accept custom branch naming" {
    BRANCH_NAMES=(
        !
        qwe
        ewsfg32
        fesw/43/wet
        32/fix
    )

    for BRANCH in ${BRANCH_NAMES[@]}; do
        test_via_commit ${BRANCH} 1
    done
}


@test "issue_type must be lowercase" {
    ISSUE_TYPES=(
        featUre
        FIX
        ImproVe
    )

    for TYPE in ${ISSUE_TYPES[@]}; do
        test_via_commit ${TYPE}/short_description 1
    done
}


@test "TODO: branch name must have short_description" {
    skip
    BRANCH_NAMES=(
        test
        test/21
        test/TASK-42
    )

    for BRANCH in ${BRANCH_NAMES[@]}; do
        test_via_commit ${BRANCH} 1
    done
}


@test "support right issue ID format" {
    BRANCH_NAMES=(
        test/EXAMPLE-42/short_description
        test/21/short_description
        test/QQ-1/short_description
        test/MODULES/some-module/QQ-3/short_description
    )

    for BRANCH in ${BRANCH_NAMES[@]}; do
        test_via_commit ${BRANCH} 0
    done
}


@test "unsupport wrong issue ID format" {
    BRANCH_NAMES=(
        test/E42/short_description
        test/qq-1/short_description
        test/1_1/short_description
        test/MODULES/some-module/44-3/short_description
    )

    for BRANCH in ${BRANCH_NAMES[@]}; do
        test_via_commit ${BRANCH} 1
    done
}


@test "not allowed non-ASCII file name" {
    test_via_commit test/short_description 1 тест_файл
}


@test "allowed trailing spaces in ignored formats" {
    EXTENTIONS=(
        "md"
        "rst"
    )

    for EXTENTION in ${EXTENTIONS[@]}; do
        test_via_commit test/short_description 0 "file.${EXTENTION}" "space  " "trailing_space_test"
    done
}


@test "not allowed trailing spaces" {
    EXTENTIONS=(
        "tf"
        "py"
    )

    for EXTENTION in ${EXTENTIONS[@]}; do
        test_via_commit test/short_description 1 "file.${EXTENTION}" "space  " "trailing_space_test"

    done
}

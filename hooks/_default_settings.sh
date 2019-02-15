#!/bin/bash

JIRA_REGEX='^[A-Z]{2,}-[0-9]+' # Default format: https://tinyurl.com/yd48c5op
GITHUB_REGEX='^[0-9]+$'


##########################
####### pre-commit #######
##########################

FOOTER="\n
Our style guide can be found at:
https://github.com/pdffiller/styleguide-hooks#branch-naming-format

A quick way to rename your branch:
git branch -m NEW_BRANCH_NAME
"

COLOR_INFO="Light_Blue"
COLOR_WARNING="Yellow"

IGNORE_TRAILING_SPACE_EXTENTIONS="md|rst"

INTERACTIVE_MODE="disabled"
FORCE_WARNING_TO_ERROR="disabled"

##########################
### prepare-commit-msg ###
##########################

STYLE_GUIDE_LINK="https://github.com/pdffiller/styleguide-hooks#commit-message-format"

declare -A JIRA_ISSUE_LINK=(
    ["org_name_in_github"]="https://org_name_in_jira.atlassian.net/browse"
    ["org_name2_in_github"]="https://org_name2_in_jira.atlassian.net/browse"
)

##########################
##### post-checkout ######
##########################

CHECK_FOR_UPDATES_EVERY='1 week' # format as in `date` command (without 'ago')

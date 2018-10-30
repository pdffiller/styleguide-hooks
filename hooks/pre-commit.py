#!/usr/bin/env python3
import re
from subprocess import check_output

footer = f'Our style guide can be found at:\n\
https://github.com/pdffiller/styleguide-hooks#branch-naming-format\n\
\n\
Quickly rename branch:\n\
git branch -m NEW_BRANCH_NAME'


# Figure out which branch we're on
try:
    branch = check_output(['git', 'symbolic-ref', '--short', 'HEAD']).strip().decode('utf-8')
except:
    # When rebase running and just reword commit
    # error: "fatal: ref HEAD is not a symbolic ref"
    # Have directory: "".git/rebase-merge"
    exit(0)


first_word = re.match(r'\w+', branch, flags=re.IGNORECASE)

# Check for crachers
if not first_word:
    exit(f'Are you DevQAOps?\nPlease, read style guide.\n\n{footer}')

# Check is branch has branch type
first_word = first_word.group(0).lower()

branch_types = [
    'feature',
    'improve',
    'fix',
    'test',
    'docs',
    'style',
    'refactor',
    'legacy',
]

for i in range(len(branch_types)):
    if branch_types[i] == first_word:
        break

    if i == len(branch_types) - 1:
        exit(f'Check branch type. Get \'{first_word}\' but it should start from {branch_types}\
\n\n{footer}')


# Check is branch have any description
branch_description = re.search(r'/', branch)

if not branch_description:
    exit(f'Check branch description. In \'{branch}\' not found any decription by pattern:\n\
issue_type / [path_to_folder /] [Jira issue ID /| GitHub issue # /] short_description\n\
Prefered construction: issue_type/Jira issue ID/short_description\
\n\n{footer}')


# Check is jira issue have mistake in it name
jira_issue_name = re.search(r'/(\w+_\d+)', branch, flags=re.IGNORECASE)

if jira_issue_name:
    jira_issue_name = jira_issue_name.group(1).upper()
    exit(f'Looks like mistake in Jira issue name.\n\
Got \'{jira_issue_name}\', but should be like \'PRJ-1234\'\
\n\n{footer}')

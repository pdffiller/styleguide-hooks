#!/usr/bin/env python3

"""
Propose:
Automate apply styleguide protection to many repos

Prerequrements:
1. Python 3.6+
2. Setup enforce_branch_protection_settings.py from example
2.1. Oauth token with access to repos. User must be owner or admin

Docs: https://developer.github.com/v3/repos/branches/
"""

import requests
import json
from enforce_branch_protection_settings import TOKEN, REPOS



def get_branch_names(token, repo_owner, repo_name):
    """
    :param token: str
    :param repo_owner: str
    :param repo_name: str
    :return: array of strings
    """

    branch_names = []

    url = f'https://api.github.com/repos/{repo_owner}/{repo_name}/branches'

    headers = {'Authorization': f'token {token}'}
    r = requests.get(url, headers=headers)
    branches = json.loads(r.text)

    for i in branches:
        branch_names.append(i['name'])

    return branch_names



def ignore_work_branches(branches):
    """
    Ignoring working branch for reduce number of request to API -
    it's longest operations.

    :param brances: array of strings
    :return: array of strings
    """
    non_work_branches = branches

    work_branches = [
        'feature',
        'improve',
        'fix',
        'test',
        'docs',
        'style',
        'refactor',
        'legacy',
    ]

    for i in branches:
        for j in work_branches:
            if i.startswith(j):
                non_work_branches.remove(i)

    return non_work_branches



def get_branches_in_need_of_protection(branch_names):
    """
    :param brances: array of strings
    :return: array of strings
    """

    branches_for_protection = []

    must_protect = [
        'master',
        'stable',
    ]

    for i in branch_names:
        if i in must_protect:
            branches_for_protection.append(i)

    return branches_for_protection



def get_protected_branches(token, repo_owner, repo_name, branches):
    """
    :param token: str
    :param repo_owner: str
    :param repo_name: str
    :param branches: array of strings
    :return: array of strings
    """

    protected_branches = []

    for branch in branches:
        url = f'https://api.github.com/repos/{repo_owner}/{repo_name}/branches/{branch}'

        headers = {'Authorization': f'token {token}'}
        r = requests.get(url, headers=headers)
        branch = json.loads(r.text)

        if branch['protection']['enabled']:
            protected_branches.append(branch['name'])

    return protected_branches



def update_protection(token, repo_owner, repo_name, branches, teams):
    """
    :param token: str
    :param repo_owner: str
    :param repo_name: str
    :param branches: array of strings
    :param teams: array of strings
    :return: True
    """

    settings = json.dumps({
        "required_status_checks": {
            "strict": True,
            "contexts": ["WIP"]
        },
        "enforce_admins": True,
        "required_pull_request_reviews": {
            "dismiss_stale_reviews": True,
            "require_code_owner_reviews": False,
        },
        "restrictions": {
            "users": [],
            "teams": teams
        }
    })

    for branch in branches:
        url = f'https://api.github.com/repos/{repo_owner}/{repo_name}/branches/{branch}/protection'

        headers = {'Authorization': f'token {token}'}
        r = requests.put(url, data=settings, headers=headers)

        response = json.loads(r.text)

        try:
            response['url']
        except:
            if response['message'] == 'Not Found':
                print(f'ERROR: Can\'t update branch settings in '
                      f'"{repo_owner}/{repo_name}:{branch}": Have no permissions')
            else:
                print(f'ERROR: Can\'t update branch settings in '
                      f'"{repo_owner}/{repo_name}:{branch}": {response}')
        else:
            print(f'Successfully update branch settings in '
                  f'"{repo_owner}/{repo_name}:{branch}"')

    return True



if __name__ == '__main__':

    for repo_owner in REPOS:
        for repo_name in REPOS[repo_owner]:

            branches = get_branch_names(TOKEN, repo_owner, repo_name)
            branches = ignore_work_branches(branches)

            branches_for_protection = get_branches_in_need_of_protection(branches)
            protected_branches = get_protected_branches(TOKEN, repo_owner, repo_name, branches)

            for i in branches_for_protection:
                if i not in protected_branches:
                    protected_branches.append(i)

            teams = REPOS[repo_owner][repo_name]
            update_protection(TOKEN, repo_owner, repo_name, protected_branches, teams)

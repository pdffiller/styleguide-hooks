
# https://developer.github.com/v3/auth/#working-with-two-factor-authentication
TOKEN = ''

# Structure:
# REPOS = {
#     'repo_owner': {
#         'repo_name': ['team which can push to protected branch', 'another team']
#     }
# }
REPOS = {
    'pdffiller': {
        'styleguide-hooks': ['DevOps']
    }
}

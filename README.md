Extremely simple merging bot, which processes webhook notifications
from Travis and automatically merges commits which passed build into
a specific branch.

#### Run it on Heroku

1. Clone the repository
2. Create a Heroku app
3. Fetch your Travis CI user token from the profile page
4. Set the TRAVIS_USER_TOKEN environment variable
5. Set the ORIGIN_REPO environment variable (in form ":username/:repo")
6. Set the DEST_BRANCH environment variable
7. Create Github [personal access token](https://github.com/settings/tokens/new)
8. Set the GITHUB_TOKEN environment variable

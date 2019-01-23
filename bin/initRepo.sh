#!/bin/bash
#
# sets up an ssh key and enables push access to the git repository
#

# exclusion list workaround
# see https://community.atlassian.com/t5/Bitbucket-Pipelines-articles/Pushing-back-to-your-repository/ba-p/958407
echo "setting remote url"
git remote set-url origin ${BITBUCKET_GIT_HTTP_ORIGIN}

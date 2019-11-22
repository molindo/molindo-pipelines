#!/bin/bash -e

branch=${BITBUCKET_BRANCH?}

# force env variables used by awscli
key=${AWS_ACCESS_KEY_ID?}
secret=${AWS_SECRET_ACCESS_KEY?}

echo "building branch ${branch}"

if [ "$USE_DYNAMO_DB" != true ]; then
    args="-DincrementalVersion=${BITBUCKET_BUILD_NUMBER?}"
fi

ant -f /usr/local/bin/build.xml -Dbasedir=. \
  -Dgit.branch=${branch} \
  -Dgit.origin=`git remote get-url origin` \
  -Dmvn=/usr/bin/mvn \
  -Daws=/usr/local/bin/aws \
  $args dist

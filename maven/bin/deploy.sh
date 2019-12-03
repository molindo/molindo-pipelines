#!/bin/bash -e

branch=${BITBUCKET_BRANCH?}

# force env variables used by awscli
key=${AWS_ACCESS_KEY_ID?}
secret=${AWS_SECRET_ACCESS_KEY?}

echo "building branch ${branch}"

args=""

if [ "$USE_DYNAMO_DB" != true ]; then
    args="$args -DincrementalVersion=${BITBUCKET_BUILD_NUMBER?}"
fi

if [ -n "$CONTAINER_TAGS" ]; then
    args="$args -DcontainerTagsFileName=${CONTAINER_TAGS}"
fi

ant -f /usr/local/bin/build.xml -Dbasedir=. -Dgit.branch=${branch} -Dmvn=/usr/bin/mvn -Daws=/usr/local/bin/aws $args dist

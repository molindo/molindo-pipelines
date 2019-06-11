#!/bin/bash -e

branch=${BITBUCKET_BRANCH?}
owner=${BITBUCKET_REPO_OWNER?}
slug=${BITBUCKET_REPO_SLUG?}

version=$( /usr/local/bin/buildNumber.sh "${owner}/${slug}:${branch}" )

echo "building branch ${branch} with version ${version}"

ant -f /usr/local/bin/build.xml -Dbasedir=. -Dgit.branch=${branch} -DincrementalVersion=${version} -Dmvn=/usr/bin/mvn dist

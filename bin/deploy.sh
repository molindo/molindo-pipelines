#!/bin/bash -e

branch=${BITBUCKET_BRANCH?}
version=${BITBUCKET_BUILD_NUMBER?}

echo "building branch ${branch} with version ${version}"

ant -f /usr/local/bin/build.xml -Dbasedir=. -Dgit.branch=${branch} -DincrementalVersion=${version} -Dmvn=/usr/bin/mvn dist

#!/bin/bash -e

# force env variables used by awscli
key=${AWS_ACCESS_KEY_ID?}
secret=${AWS_SECRET_ACCESS_KEY?}

echo "building branch ${branch}"

ant -f /usr/local/bin/build.xml -Dbasedir=. -Dgit.branch=${branch} -Dmvn=/usr/bin/mvn -Daws=/usr/local/bin/aws dist

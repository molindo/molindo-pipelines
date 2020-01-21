#!/bin/sh -e

# generate container-tags file for non-maven jobs (e.g. docker-only builds)

function version {
  key=${1:?}

  aws --region eu-central-1 dynamodb update-item \
    --table-name pipelines-versions \
    --return-values ALL_NEW \
    --key "{\"artifact\": {\"S\": \"${key}\"}}" \
    --expression-attribute-names '{"#V":"version"}' \
    --expression-attribute-values '{":one": {"N": "1"}}' \
    --update-expression 'ADD #V :one' \
    --query Attributes.version.N --output text
}

# args
name=${1:-${BITBUCKET_REPO_SLUG:?}}
defaultBranch=${2:-master}

# vars
branch=${BITBUCKET_BRANCH:?}
commit=${BITBUCKET_COMMIT:?}
tagFile=container-tags.txt

# force env variables used by awscli
awsKey=${AWS_ACCESS_KEY_ID?}
awsSecret=${AWS_SECRET_ACCESS_KEY?}

if [ "$branch" = "$defaultBranch" ]; then
	# default build
	version=`version $name`
	echo "$name:$version" > $tagFile
	echo "$name:latest" >> $tagFile
else
	# branch build
	echo "$name:$commit" > $tagFile
	echo "$name:$branch" >> $tagFile
fi

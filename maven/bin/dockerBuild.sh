#!/bin/bash -e
#
# build Dockerfile and push to ECR registry
#

# pipelines env
slug=${BITBUCKET_REPO_SLUG?}
commit=${BITBUCKET_COMMIT?}
branch=${BITBUCKET_BRANCH}

# required variables
registry=${MOLINDO_DOCKER_REGISTRY?}
bucket=${MOLINDO_DOCKER_BUCKET?}

# force env variables used by awscli
key=${AWS_ACCESS_KEY_ID?}
secret=${AWS_SECRET_ACCESS_KEY?}

# optional variables
tags=${CONTAINER_TAGS:-container-tags.txt}

# optional args
path=${1:-.}

target=$slug:$commit

if [ -n -e $tags ]; then
	echo -n $registry/$target > $tags
fi

# ECR login
if [ `echo $registry | grep 'ecr\.[^.]*\.amazonaws\.com$'` ]; then
	region=`echo $registry | sed -e 's/^.*\.\([^.]*\)\.amazonaws\.com$/\1/g'`
	echo "logging in to AWS ECR in $region"
	$( aws --region $region ecr get-login --no-include-email )
fi

echo "building $target"
docker build -t $target $path

while read tag; do
	if [ -n "$tag"]; then
		echo "pushing $registry/$tag"
		docker tag $target $registry/$tag
		docker push $registry/$tag
	fi
done < $tags

if [ -n "$branch"]; then
	aws s3api put-object --bucket $bucket --key artifacts/${branch}/${slug}-container-tags.txt --body ${tags}
fi

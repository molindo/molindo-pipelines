#!/bin/bash -e
#
# build Dockerfile and push to ECR registry
#

# pipelines env
slug=${BITBUCKET_REPO_SLUG?}
commit=${BITBUCKET_COMMIT?}

# required variables
registry=${MOLINDO_DOCKER_REGISTRY?}

# optional variables
tags=${CONTAINER_TAGS:-container-tags.txt}

target=$slug:$commit

if [ -n -e $tags ]; then
	echo -n $registry/$target > $tags
fi

# ECR login
if [ `echo $registry | grep 'ecr\.[^.]*\.amazonaws\.com$'` ]; then
	# force env variables used by awscli
	key=${AWS_ACCESS_KEY_ID?}
	secret=${AWS_SECRET_ACCESS_KEY?}

	region=`echo $registry | sed -e 's/^.*\.\([^.]*\)\.amazonaws\.com$/\1/g'`
	echo "logging in to AWS ECR in $region"
	$( aws --region $region ecr get-login --no-include-email )
fi

echo "building $target"
docker build -t $target .

while read tag; do
	if [ -n "$tag"]; then
		echo "pushing $registry/$tag"
		docker tag $target $registry/$tag
		docker push $registry/$tag
	fi
done < $tags

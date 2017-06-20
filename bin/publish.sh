#!/bin/bash -e
#
# set version and publish to registry
#

# pipelines env
branch=${BITBUCKET_BRANCH?}
repoSlug=${BITBUCKET_REPO_SLUG?}

# read current version
version=$(npm show $repoSlug version)
major="$(echo $version | cut -d'.' -f1)"
minor="$(echo $version | cut -d'.' -f2)"
patch="$(echo $version | cut -d'.' -f3 | cut -d'-' -f1)"

# increment patch version
patch="$(($patch + 1))"
newVersion="$major.$minor.$patch"

# set prerelease suffix for non-master builds
if [ $branch != "master" ]; then
  curTime=$(date +%s)
  newVersion="$newVersion-$branch.$curTime"
fi

echo "incrementing version from $version to $newVersion"

# write new version to package.json
npm --no-git-tag-version version $newVersion

# publish
tag=$([ $branch = "master" ] && echo "latest" || echo "prerelease")
npm publish --tag $tag

#!/bin/bash -e
#
# set version and publish to registry
#

# pipelines env
branch=${BITBUCKET_BRANCH?}
repoSlug=${BITBUCKET_REPO_SLUG?}
defaultBranches=${DEFAULT_BRANCHES:-master}

function branchType () {
  for b in ${defaultBranches}; do
    [[ "$b" == "$1" ]] && echo default && return;
  done
  echo feature
}

# detect if the build is for a default branch
case `branchType $branch` in
"default")
  isDefaultBranch=true
  ;;
*)
  isDefaultBranch=false
  ;;
esac

# read current version
version=$(npm show $repoSlug version)
major="$(echo $version | cut -d'.' -f1)"
minor="$(echo $version | cut -d'.' -f2)"
patch="$(echo $version | cut -d'.' -f3 | cut -d'-' -f1)"

# increment patch version
patch="$(($patch + 1))"
newVersion="$major.$minor.$patch"

# set prerelease suffix for builds on non-default branches
if [ $isDefaultBranch != true ]; then
  curTime=$(date +%s)
  newVersion="$newVersion-$branch.$curTime"
fi

echo "incrementing version from $version to $newVersion"

# write new version to package.json
npm --no-git-tag-version version $newVersion

# publish
tag=$([ $isDefaultBranch == true ] && echo "latest" || echo "prerelease")
npm publish --tag $tag

# tag release
if [ $isDefaultBranch == true ]; then
  echo "tagging version $newVersion"
  git tag $newVersion
  git push origin $newVersion
fi

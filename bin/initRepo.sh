#!/bin/bash
#
# sets up an ssh key and enables push access to the git repository
#

owner=${BITBUCKET_REPO_OWNER?}
slug=${BITBUCKET_REPO_SLUG?}
user=${GIT_USER_NAME?}
email=${GIT_USER_EMAIL?}

if [ ! -e ~/.ssh/id_rsa ]; then
  key=${SSH_KEY?}
  echo "adding ssh key"
  mkdir -p ~/.ssh
  echo $key | base64 -d > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
else
  echo "using existing ssh key"
fi

echo "adding bitbucket.org as known host"
ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts

echo "configuring git user"
git config --global user.name "$user"
git config --global user.email "$email"

echo "setting remote url"
git remote set-url origin git@bitbucket.org:${owner}/${slug}.git

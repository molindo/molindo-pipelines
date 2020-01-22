#!/bin/bash
#
# sets up an ssh key and enables push access to the git repository
#

user=${GIT_USER_NAME?}
email=${GIT_USER_EMAIL?}

if [ -n "$SSH_KEY" ]; then
  key=${SSH_KEY?}

  echo "adding ssh key"
  mkdir -p ~/.ssh
  echo $key | base64 -d > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa

  echo "adding bitbucket.org as known host"
  ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts

  echo "setting SSH remote URL ${BITBUCKET_GIT_SSH_ORIGIN}"
  git remote set-url origin ${BITBUCKET_GIT_SSH_ORIGIN?}
else
  echo "setting HTTP remote URL ${BITBUCKET_GIT_HTTP_ORIGIN}"
  git remote set-url origin ${BITBUCKET_GIT_HTTP_ORIGIN?}
fi

echo "configuring git user"
git config --global user.name "$user"
git config --global user.email "$email"

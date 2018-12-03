# molindo-pipelines

Container for use as Bitbucket Pipelines image

- awscli and jshon installed
- scripts for Docker and Bamboo integration
- auto publishing of libraries

## Registry

Built and [hosted on Docker Hub](https://hub.docker.com/r/molindo/molindo-pipelines/)

## Usage

### Define these variables:

- `MOLINDO_DOCKER_REGISTRY` - ECR registry hostname (e.g. "123456789012.dkr.ecr.eu-west-1.amazonaws.com")
- `AWS_ACCESS_KEY_ID` - AWS key id for ECR login
- `AWS_SECRET_ACCESS_KEY` - AWS secret access key for ECR login
- `BAMBOO_ROOT` - URL of Bamboo instance without trailing slash (e.g. "http://example.com/bamboo")
- `BAMBOO_PLAN` - the Bamboo plan key (e.g. "FOO-BAR")
- `BAMBOO_USER` - user name of a Bamboo user with admin privileges (required to create branches)
- `BAMBOO_PASS` - password for Bamboo user
- `BITBUCKET_BRANCH` - current branch name
- `BITBUCKET_REPO_SLUG` - slug of the repository name
- `DEFAULT_BRANCHES` - a space separated list of branches that will publish stable releases when built upon (e.g. `master 1.x`)
- `GIT_USER_NAME` - user name of a git user that has push access to the repository
- `GIT_USER_EMAIL` - email of a git user that has push access to the repository
- `NPM_BUILD_USER` - npm registry user
- `NPM_BUILD_PASS` - npm registry password

### Add bitbucket-pipelines.yml

```yml
image: molindo/molindo-pipelines:nodejs-7

pipelines:
  default:
    - step:
        script:
          - . /etc/profile
          - initRepo.sh
          - yarn install
          - npm run build
          - dockerBuild.sh
          - triggerBamboo.sh

options:
  docker: true
```

### Libraries

For automatic publishing of libraries, the script `publish.sh` can be added as a build step. It increments patch versions depending on the last published version.

For the script to work, at least one version needs to be published before the script runs the first time. The version that's specified in `package.json` is ignored and can therefore hold arbitrary values like `0.0.9999`.

For minor and major version bumps, the developer should take care of the publishing before merging into master.

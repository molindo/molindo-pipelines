# molindo-pipelines:maven

Container for use as Bitbucket Pipelines image

- awscli and jshon installed
- scripts for Docker and Bamboo integration

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
- `BITBUCKET_BUILD_NUMBER` - current build number
- `GIT_USER_NAME` - user name of a git user that has push access to the repository
- `GIT_USER_EMAIL` - email of a git user that has push access to the repository

### Add bitbucket-pipelines.yml

For libraries:

```yml
image: molindo/molindo-pipelines:maven

clone:
  depth: full

pipelines:
  default:
    - step:
        caches:
          - maven
        script:
          - initRepo.sh
          - deploy.sh
```

For containers:

```yml
image: molindo/molindo-pipelines:maven

clone:
  depth: full

pipelines:
  default:
    - step:
        caches:
          - maven
        script:
          - initRepo.sh
          - deploy.sh
          - dockerBuild.sh target/
          - triggerBamboo.sh
        artifacts:
          - container-tags.txt

options:
  docker: true
```

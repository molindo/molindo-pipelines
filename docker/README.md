# molindo-pipelines:docker

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
- `BAMBOO_PLAN` or `BAMBOO_CHILD_PLAN` - the Bamboo plan key (e.g. "FOO-BAR")
- `BAMBOO_USER` - user name of a Bamboo user with admin privileges (required to create branches)
- `BAMBOO_PASS` - password for Bamboo user
- `GIT_USER_NAME` - user name of a git user that has push access to the repository
- `GIT_USER_EMAIL` - email of a git user that has push access to the repository

### Expected Pipelines variables:

- `BITBUCKET_REPO_SLUG` - slug of the repository name
- `BITBUCKET_BRANCH` - current branch name
- `BITBUCKET_COMMIT` - current commit id

(see ["Variables in Pipelines"](https://confluence.atlassian.com/bitbucket/variables-in-pipelines-794502608.html))

### Add bitbucket-pipelines.yml

```yml
image: molindo/molindo-pipelines:maven

pipelines:
  default:
    - step:
        script:
          - initRepo.sh
          - generateContainerTags.sh
          - dockerBuild.sh
          - triggerBamboo.sh
        artifacts:
          - container-tags.txt

options:
  docker: true
```

#!/bin/bash -e
#
# trigger bamboo build for same commit
#

if [ -z "${BITBUCKET_BRANCH}" ]; then
        echo "not a branch build, exiting"
        exit 0
fi

# pipelines env
branch=${BITBUCKET_BRANCH?}
commit=${BITBUCKET_COMMIT?}

# required variables
bamboo=${BAMBOO_ROOT?}
plan=${BAMBOO_PLAN?}
user=${BAMBOO_USER?}
pass=${BAMBOO_PASS?}

echo "triggering build for ${plan}"
if [ "${branch}" = "master" ]; then
    branchKey=${plan}
else
    echo "getting branch key for ${branch}"
    branchKey=$( curl -s --user "${user}:${pass}" -H 'Accept: application/json' ${bamboo}/rest/api/latest/plan/${plan}/branch/${branch} | jshon -e key -u 2> /dev/null || echo "" )

    if [ -z "${branchKey}" ]; then
            echo "creating new branch ${branch} of plan ${plan}"
            branchKey=$( curl -s --user "${user}:${pass}" -H 'Accept: application/json' -XPUT "${bamboo}/rest/api/latest/plan/${plan}/branch/${branch}?vcsBranch=${branch}&enabled=true&cleanupEnabled=true" | jshon -e key -u )
    fi
fi

echo "triggering build for ${commit} in ${branchKey} with user ${user}"
resultKey=$(curl -s --user "${user}:${pass}" -H 'Accept: application/json' -XPOST ${bamboo}/rest/api/latest/queue/${branchKey}?customRevision=${commit} | jshon -e buildResultKey -u)

echo "queued build ${buildResultKey}"

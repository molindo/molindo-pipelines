#!/bin/bash -e
#
# use AWS DynamoDB to increment a counter for a given key
#

key=${1?}

# force env variables used by awscli
awsKey=${AWS_ACCESS_KEY_ID?}
awsSecret=${AWS_SECRET_ACCESS_KEY?}

aws --region eu-central-1 dynamodb update-item \
    --table-name pipelines-versions \
    --return-values ALL_NEW \
    --key "{\"artifact\": {\"S\": \"${key}\"}}" \
    --expression-attribute-names '{"#V":"version"}' \
    --expression-attribute-values '{":one": {"N": "1"}}' \
    --update-expression 'ADD #V :one' \
    --query Attributes.version.N --output text

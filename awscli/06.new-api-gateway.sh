#!/bin/bash

set -e 

export LAMBDA_ARN=`cat out/lambda_function.json | jq -r .FunctionArn`

#aws cloudformation delete-stack --stack-name feedback-api

aws cloudformation deploy \
    --template-file ../cloudFormation/apiGateway.yaml \
    --stack-name feedback-api \
    --parameter-overrides \
        lambdaFunction=$LAMBDA_ARN 


aws cloudformation describe-stacks \
    --stack-name feedback-api \
    > out/stack.json

# Test POST API
export LAMBDA_URL=`jq -r '.Stacks[0].Outputs[] | select(.OutputKey == "apiGatewayInvokeURL") | .OutputValue'  out/stack.json`

curl -v -X POST "$LAMBDA_URL/api/feedback" \
    -H "Content-Type: application/json" \
    -d "@../lambda/sample-data/test03.json"

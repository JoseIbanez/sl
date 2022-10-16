#!/bin/bash


export LAMBDA_ARN=`cat out/lambda_function.json | jq -r .FunctionArn`

aws cloudformation deploy \
    --template-file ../cloudFormation/apiGateway.yaml \
    --stack-name my-api-3 \
    --parameter-overrides \
        lambdaFunction=$LAMBDA_ARN \
        Key2=Value2 \
    --tags \
        Key1=Value1 \
        Key2=Value2

curl -X POST https://qz1b0d2vgc.execute-api.us-east-1.amazonaws.com/prod/api/feedback \
    -H "Content-Type: application/json" \
    -d "@../lambda/sample-data/test03.json"

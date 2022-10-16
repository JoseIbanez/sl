#!/bin/bash


export LAMBDA_ARN=`cat out/lambda_function.json | jq -r .FunctionArn`

aws cloudformation deploy \
    --template-file ../cloudFormation/apiGateway.yaml \
    --stack-name my-api \
    --parameter-overrides \
        lambdaFunction=$LAMBDA_ARN \
        Key2=Value2 \
    --tags \
        Key1=Value1 \
        Key2=Value2


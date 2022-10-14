#!/bin/bash


export ROLE_ARN=`cat ../awscli/out/role.json | jq -r .Role.Arn`

aws lambda create-function \
    --function-name ${LAMBDA_NAME} \
    --runtime python3.8 \
    --zip-file fileb://../lambda/dist/lambda.zip \
    --handler lambda_function.lambda_handler \
    --role ${ROLE_ARN}

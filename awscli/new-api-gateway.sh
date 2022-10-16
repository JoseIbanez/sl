#!/bin/bash

aws cloudformation deploy \
    --template-file /path_to_template/template.json \
    --stack-name my-new-stack \
    --parameter-overrides \
        Key1=Value1 \
        Key2=Value2 \
    --tags \
        Key1=Value1 \
        Key2=Value2
        



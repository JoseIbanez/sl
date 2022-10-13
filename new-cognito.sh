#!/bin/bash
set -e


export COGNITO_USERPOOL="Feedback"
export WEB_APPLICATION="WebApp"
export POOL_DOMAIN=`echo $BUCKETNAME | tr '[:upper:]' '[:lower:]'`


# Create cognito user pool
aws cognito-idp create-user-pool \
    --username-attributes "email" \
    --schema \
    Name=name,Mutable=true,Required=true \
    Name=phone_number,Mutable=true,Required=true \
    --pool-name $COGNITO_USERPOOL > out/cognito.json

export USERPOOL_ID=`cat out/cognito.json | jq -r .UserPool.Id`


# Add web application
aws cognito-idp create-user-pool-client \
    --user-pool-id $USERPOOL_ID \
    --generate-secret \
    --prevent-user-existence-errors "ENABLED" \
    --client-name $WEB_APPLICATION \
    --explicit-auth-flows "ALLOW_CUSTOM_AUTH" "ALLOW_USER_SRP_AUTH" "ALLOW_REFRESH_TOKEN_AUTH" \
    --supported-identity-providers "COGNITO" \
    --allowed-o-auth-flows-user-pool-client \
    --allowed-o-auth-flows "implicit" \
    --allowed-o-auth-scopes "email" "openid" \
    --callback-urls https://boliche.ovh \
    --logout-urls https://boliche.ovh \
    > out/cognito_client.json


# Configure domain
aws cognito-idp create-user-pool-domain \
    --user-pool-id $USERPOOL_ID \
    --domain $POOL_DOMAIN \
    > out/cognito_domain.json
    
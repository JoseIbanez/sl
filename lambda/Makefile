include: ../aws_cli/sl_vars.sh

list:
	aws lambda list-functions --max-items 50 | jq '.Functions[].FunctionArn'


build:
	mkdir -p ./dist/
	cd src; zip -r ../dist/lambda.zip .

get:
	aws lambda get-function \
		--function-name ${LAMBDA_NAME}


update-layer:

	rm -rf ./python/

	python -m pip install -r requirements.txt -t ./python

	zip -r ./dist/layer.zip ./python

	aws lambda publish-layer-version \
		--layer-name jinja2 \
		--zip-file fileb://dist/layer.zip \
		--compatible-runtimes python3.8 \
		--region eu-west-1


publish:
	rm -f ./dist/lambda.zip
	cd src; zip -r ../dist/lambda.zip .
	aws lambda update-function-code \
		--function-name ${LAMBDA_NAME} \
		--region eu-west-1 \
		--zip-file fileb://dist/lambda.zip 


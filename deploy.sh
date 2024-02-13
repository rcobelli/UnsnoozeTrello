#!/bin/bash

AWS_CLI_PROFILE=${1:-default}

rm deployment_package.zip 2> /dev/null || true

echo "Packaging application..."
pip3 install --target ./package requests
cd package
zip -r ../deployment_package.zip . 
cd ..
zip deployment_package.zip lambda_function.py
echo "Done."

echo "Looking for existing CloudFormation S3 bucket..."
BUCKET_NAME=$(aws s3api list-buckets --profile $AWS_CLI_PROFILE --output text --query "Buckets[].[Name]" | grep cf-templates | cat)

if [[ -z "$BUCKET_NAME" ]]; then
   echo "No matches found."
   BUCKET_SUFFIX=$(xxd -l 8 -c 8 -p < /dev/random)
   BUCKET_NAME="cf-templates-${BUCKET_SUFFIX}"
   echo "Creating new bucket..."
   aws s3api create-bucket --bucket $BUCKET_NAME --profile $AWS_CLI_PROFILE
   echo "Done."
fi

echo "Using bucket: ${BUCKET_NAME}.";

aws cloudformation package --template-file cfn-template.yml --s3-bucket $BUCKET_NAME --output-template-file template.packaged.yml --profile $AWS_CLI_PROFILE
aws cloudformation deploy --template-file template.packaged.yml --stack-name UnsnoozeTrello --parameter-overrides file://params.json --capabilities CAPABILITY_NAMED_IAM --profile $AWS_CLI_PROFILE
#!/bin/bash

set -e # Early return any commands fails

AWS_BUCKET_NAME=$1
AWS_REGION=$2


aws s3api create-bucket \
  --bucket "$AWS_BUCKET_NAME" \
  --region "$AWS_REGION" \
  --create-bucket-configuration \
      LocationConstraint="$AWS_REGION"
      
# Enable versioning
aws s3api put-bucket-versioning \
  --bucket "$AWS_BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket "$AWS_BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules":[{
      "ApplyServerSideEncryptionByDefault":{
        "SSEAlgorithm":"AES256"
      }
    }]
  }'

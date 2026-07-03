#!/bin/bash

set -e # Early return any commands fails

CLUSTER_NAME=$1
AWS_ACCOUNT_ID=$2
AWS_REGION=$3
VPC_ID=$4

# # Create IAM OIDC provider
# eksctl utils associate-iam-oidc-provider \
#     --region <region-code> \
#     --cluster <your-cluster-name> \
#     --approve
    
# Create IAM role

# Download IAM policy for AWS LBC
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.14.1/docs/install/iam_policy.json

# Create IAM policy using downloaded policy file
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

# Create IAM service account
eksctl create iamserviceaccount \
    --cluster="$CLUSTER_NAME" \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::"$AWS_ACCOUNT_ID":policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region "$AWS_REGION" \
    --approve


# Install AWS LBC

# Add eks-charts helm chart repo
helm repo add eks https://aws.github.io/eks-charts

# Update local repo
helm repo update eks

# Install LBC
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$CLUSTER_NAME" \
  --set region="$AWS_REGION" \
  --set vpcId="$VPC_ID" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set controllerConfig.featureGates.NLBGatewayAPI=true \
  --set controllerConfig.featureGates.ALBGatewayAPI=true \
  --version 3.0.0

# Verify controller installed
kubectl get deployment -n kube-system aws-load-balancer-controller
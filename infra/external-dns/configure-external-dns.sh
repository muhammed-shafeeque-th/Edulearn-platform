#!/bin/bash

set -e # Early return any commands fails

CLUSTER_NAME=$1

aws iam create-policy --policy-name "AllowExternalDNSUpdates" --policy-document file://policy.json

# example: arn:aws:iam::XXXXXXXXXXXX:policy/AllowExternalDNSUpdates
POLICY_ARN=$(aws iam list-policies \
 --query 'Policies[?PolicyName==`AllowExternalDNSUpdates`].Arn' --output text)

# Create namespace
kubectl create ns external-dns

eksctl create podidentityassociation \
  --cluster "$CLUSTER_NAME" \
  --namespace external-dns \
  --service-account-name external-dns \
  --role-name external-dns-pod-identity-role \
  --permission-policy-arns "$POLICY_ARN"

# Add repo
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/

# deploy in a separte namespace

helm install external-dns external-dns/external-dns -n external-dns --version 1.20.0

# Verify pods
kubectl get pod -n external-dns

#helm show values external-dns/external-dns --version 1.20.0 > external-dns-values-1.20.0.yaml

# Upgrade the install
helm upgrade -i external-dns external-dns/external-dns -f external-dns-values-1.20.0.yaml -n external-dns --version 1.20.0
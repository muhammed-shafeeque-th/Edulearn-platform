#!/bin/bash

set -e # Early return any commands fails

CLUSTER_NAME=$1
AWS_REGION=$2

aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME" 

# Validate
kubectl get nodes
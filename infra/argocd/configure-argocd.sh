#!/bin/bash

set -e # Early return any commands fails

# Add ArgoCd repo
helm repo add argo https://argoproj.github.io/argo-helm

# Get values
# helm show values argo/argo-cd --version 9.4.0 > argocd-values-9.4.0.yaml

# Install the chart and create ns if not present
helm install argo-cd argo/argo-cd -n argocd -f argocd-values-9.4.0.yaml --version 9.4.0 --create-namespace

# Apply TargetGroupConfig
kubectl apply -f target-grp-config.yaml 

# Command to fetch passwd
#get auto generated password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Apply argocd App manifest
kubectl apply -f applications/edulearn-app.yaml
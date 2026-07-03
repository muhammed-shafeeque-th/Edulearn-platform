#!/bin/bash

set -e # Early return any commands fails

# Add ArgoCd repo
# helm repo add argo https://argoproj.github.io/argo-helm

# Install argo image updater
helm install argocd-image-updater argo/argocd-image-updater -n argocd --version 1.0.5

# Verify pods
kubectl get po -n argocd

# Apply argocd image updater manifest
kubectl apply -f image-updater.yaml

# Verify pod
kubectl get imageupdater -n argocd
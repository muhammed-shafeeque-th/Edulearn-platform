#!/bin/bash

set -e # Early return any commands fails

CLUSTER_NAME=$1


# Add Helm repo
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

# Install
kubectl create ns external-secrets --dry-run=client -o yaml | kubectl apply -f -

aws iam create-policy \
  --policy-name ExternalSecretsManagerRead \
  --policy-document file://policy.json


POLICY_ARN=$(aws iam list-policies \
 --query 'Policies[?PolicyName==`ExternalSecretsManagerRead`].Arn' --output text)

# Create namespace

eksctl create podidentityassociation \
  --cluster "$CLUSTER_NAME" \
  --namespace external-secrets \
  --service-account-name external-secrets \
  --role-name external-secrets-pod-identity-role \
  --permission-policy-arns "$POLICY_ARN"


helm install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --set installCRDs=true \
  --version 0.15.0

kubectl get pods -n external-secrets

kubectl get externalsecret -n edulearn
kubectl get secret edulearn-secrets -n edulearn -o yaml
kubectl get pods -n edulearn





# kubectl logs <pod-name> -n edulearn | grep DATABASE




# aws iam create-role \
#   --role-name external-secrets-role \
#   --assume-role-policy-document file://role-policy.json

# aws eks create-pod-identity-association \
#   --cluster-name "$CLUSTER_NAME" \
#   --namespace external-secrets \
#   --service-account external-secrets-sa \
#   --role-arn arn:aws:iam::"$ACCOUNT_ID":role/external-secrets-role



# OIDC_URL=$(aws  eks describe-cluster --name "$CLUSTER_NAME" --query "cluster.identity.oidc.issuer" --output text)
# # Attach policy to role
# aws iam attach-role-policy \
#   --role-name edulearn-external-secrets-role \
#   --policy-arn arn:aws:iam::YOUR_ACCOUNT_ID:policy/EduLearn-SecretsManager-Read


# # Create secret for common / shared
# aws secretsmanager create-secret \
#   --name edulearn/production/common \
#   --secret-string '{
#     "GLOBAL_JWT_SECRET": "super-long-random-key",
#     "REDIS_PASSWORD": "redis-secure-pass-123"
#   }'

# # Service-specific secrets
# aws secretsmanager create-secret \
#   --name edulearn/production/auth \
#   --secret-string '{
#     "DATABASE_PASSWORD": "auth-db-pass-123",
#     "GOOGLE_CLIENT_SECRET": "g-secret-xxx"
#   }'

# aws secretsmanager create-secret \
#   --name edulearn/production/course \
#   --secret-string '{
#     "STRIPE_SECRET_KEY": "sk_live_...",
#     "PAYMENT_WEBHOOK_SECRET": "whsec_..."
#   }'

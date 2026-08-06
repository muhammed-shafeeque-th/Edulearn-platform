
# Deployment Architecture

## Overview

Edulearn follows a **three-tier deployment strategy** separating infrastructure provisioning, cluster configuration, and application delivery.

This separation provides:

* Repeatability
* Idempotency
* Security
* Scalability
* Disaster recovery
* GitOps compatibility

## Deployment Architecture

![Deployment](images/architecture-light.png)

## Layer 1 — Infrastructure Provisioning

Implemented using **Terraform**.

Directory:

```text
infra/terraform
```

Terraform provisions:

* VPC
* Public subnets
* Private subnets
* Internet Gateway
* NAT Gateway
* Route tables
* Security groups
* Bastion host
* Amazon EKS cluster
* Managed node groups
* IAM roles
* IAM policies
* OIDC provider
* Pod Identity associations
* Route53 resources
* S3 backend bucket
* EBS CSI prerequisites

### Why Terraform?

Infrastructure is managed as code.

Benefits:

* Version control
* Reproducibility
* Peer review
* Drift detection
* Environment consistency

## Layer 2 — Cluster Configuration

Implemented using **Ansible**.

Directory:

```text
infra/ansible
```

Ansible configures the Kubernetes cluster after Terraform has completed.

### Installed Components

* ArgoCD
* ArgoCD Image Updater
* AWS Load Balancer Controller
* Gateway API CRDs
* External Secrets Operator
* ExternalDNS
* kube-prometheus-stack
* Grafana
* Prometheus
* Alertmanager
* Loki
* Tempo
* Fluent Bit
* OpenTelemetry Collector

### Why Ansible?

Terraform should provision infrastructure.

Ansible should configure infrastructure.

This separation keeps infrastructure immutable while allowing application-level configuration to evolve independently.

## Layer 3 — Application Delivery

Implemented using **ArgoCD**.

Application manifests are stored in Git.

ArgoCD continuously reconciles Git state with cluster state.

### GitOps Flow

```text
Git
 |
 v
ArgoCD
 |
 v
Helm
 |
 v
Kubernetes
```

Features:

* Automated sync
* Self healing
* Drift correction
* Rollback
* Audit history

## Step-by-Step Deployment

### 1. Clone Repository

```bash
git clone https://github.com/your-org/edulearn-platform.git
cd edulearn-platform
```

### 2. Provision AWS Infrastructure

```bash
cd infra/terraform

terraform init
terraform plan
terraform apply
```

Terraform outputs:

* Bastion IP
* Cluster name
* VPC ID
* Subnet IDs

### 3. Connect Through Bastion Host

The EKS cluster is private.

```bash
ssh -i bastion-key.pem ubuntu@<bastion-ip>
```

Inside the Bastion host:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name edulearn-cluster
```

Verify:

```bash
kubectl get nodes
```

### 4. Configure the Cluster

Run Ansible:

```bash
cd infra/ansible

ansible-playbook playbooks/platform.yaml
```

This installs:

* ArgoCD
* Observability
* Gateway API
* External Secrets
* ExternalDNS

### 5. Deploy Applications

Apply ArgoCD applications:

```bash
kubectl apply -f infra/argocd/applications/
```

ArgoCD deploys all services automatically.

### 6. Verify Deployment

Check namespaces:

```bash
kubectl get ns
```

Check pods:

```bash
kubectl get pods -A
```

Check Gateway:

```bash
kubectl get gateway -A
```

Check HTTPRoutes:

```bash
kubectl get httproute -A
```

## Helm Packaging

Directory:

```text
infra/helm
```

### Library Chart

Contains reusable templates:

* Deployment
* Service
* ConfigMap
* Secret
* HPA
* ServiceMonitor
* Gateway
* Probes

### Umbrella Chart

Deploys:

* API Gateway
* Auth
* User
* Course
* Payment
* Order
* Notification
* Chat
* Redis
* Kafka
* PostgreSQL

Benefits:

* Single release
* Shared configuration
* Consistent values
* Easier upgrades
* Easier rollback

## Image Delivery

### CI

GitHub Actions:

* Test
* Build
* Trivy scan
* Push to GHCR

### CD

ArgoCD Image Updater:

* Watches GHCR
* Detects new image
* Updates Helm values
* Triggers ArgoCD sync

End-to-end:

```text
Developer
   |
GitHub
   |
GitHub Actions
   |
GHCR
   |
ArgoCD Image Updater
   |
ArgoCD
   |
EKS
```

---

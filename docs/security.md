
# Security Architecture

## Overview

Edulearn follows **defense-in-depth** and **least privilege** security principles.

Security is implemented across:

* Infrastructure
* Kubernetes
* IAM
* Networking
* Containers
* Secrets
* CI/CD

## Network Security

### Private EKS Cluster

The Kubernetes control plane is private.

Characteristics:

* No public worker nodes
* Private subnets
* Internal-only service communication
* Controlled administrative access

## Bastion Host

Administrative access is only through a Bastion host.

Flow:

```text
Engineer
 |
SSH
 |
Bastion Host
 |
Private EKS Cluster
```

Benefits:

* No direct node access
* Centralized auditing
* Restricted ingress
* Reduced attack surface

## Kubernetes Network Model

### Internal Services

Services use:

* ClusterIP
* gRPC
* Kafka
* Redis

No service is publicly exposed by default.

### External Exposure

Only selected endpoints are exposed through:

* Gateway API
* AWS ALB
* Route53

## IAM Security

### Least Privilege

Every component receives only the permissions it requires.

Examples:

* ExternalDNS
* EBS CSI Driver
* AWS Load Balancer Controller
* External Secrets
* Application Pods

## Pod Identity Agent

Applications access AWS resources using **IAM roles**, not static credentials.

Benefits:

* No AWS keys
* Automatic credential rotation
* Service isolation
* Fine-grained permissions

## Secrets Management

Secrets are stored in:

* AWS Secrets Manager

Kubernetes retrieves secrets through:

* External Secrets Operator

Flow:

```text
AWS Secrets Manager
        |
External Secrets
        |
Kubernetes Secret
        |
Application Pod
```

Secrets are **never committed to Git**.

## Container Security

Applications run with hardened settings.

### Non-root User

Containers do not run as root.

### No Sudo

Runtime images do not include:

* sudo
* package managers
* unnecessary utilities

### Minimal Images

Docker optimizations:

* multi-stage builds
* dependency pruning
* minimal runtime layers

### Security Context

Typical settings:

```yaml
runAsNonRoot: true
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
```

## Image Security

### Trivy Scanning

Every build is scanned for:

* OS vulnerabilities
* library vulnerabilities
* HIGH severity
* CRITICAL severity

Pipeline:

```text
Build
 |
Trivy
 |
GHCR
```

## CI/CD Security

### GitHub Actions

Pipelines use:

* GitHub OIDC
* short-lived credentials
* minimal permissions

### GitOps

Deployments occur through:

* ArgoCD
* Git history
* pull requests
* code review

No manual production deployments.

## Kubernetes Security

### Namespaces

Isolation:

* application
* monitoring
* logging
* argocd
* external-dns
* external-secrets

### RBAC

Access is granted by role.

Examples:

* developers
* platform engineers
* read-only observers

### Service Accounts

Each workload uses a dedicated service account.

## Security Layers

### Infrastructure

* Private VPC
* Security groups
* IAM
* Bastion host

### Kubernetes

* RBAC
* Namespaces
* Network isolation
* Service accounts

### Applications

* JWT authentication
* Input validation
* Rate limiting
* Idempotency
* Structured logging

### Containers

* Non-root execution
* Minimal images
* Read-only filesystem
* Vulnerability scanning

### Secrets

* AWS Secrets Manager
* External Secrets
* No Git secrets

## Threat Mitigation

| Threat                  | Mitigation                     |
| ----------------------- | ------------------------------ |
| Public node exposure    | Private subnets                |
| Credential leakage      | Pod Identity + Secrets Manager |
| Privilege escalation    | Non-root containers            |
| Lateral movement        | Namespace isolation + RBAC     |
| Image vulnerabilities   | Trivy scanning                 |
| Configuration drift     | GitOps                         |
| Secret exposure         | External Secrets               |
| Unauthorized AWS access | Least privilege IAM            |

## Security Principles

Edulearn follows:

* Least privilege
* Defense in depth
* Immutable infrastructure
* Zero static cloud credentials
* GitOps-based change management
* Secure-by-default networking
* Container hardening
* Full auditability

These principles ensure that the platform remains secure, reproducible, and suitable for production-grade cloud-native deployments.

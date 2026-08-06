

# Observability Architecture

## Overview

Edulearn implements full-stack observability using **OpenTelemetry** and the **LGTM stack**:

* Loki
* Grafana
* Tempo
* Prometheus

Every service is instrumented for:

* Logs
* Metrics
* Traces

## Architecture

![Observability](images/observability-flow.png)

## Components

### OpenTelemetry

All services emit:

* traces
* metrics
* log correlation

Instrumentation libraries:

* Node.js OpenTelemetry
* FastAPI OpenTelemetry
* Go OpenTelemetry

### Prometheus

Collects:

* application metrics
* Kubernetes metrics
* node metrics
* container metrics

Scraping:

```text
Service
   |
ServiceMonitor
   |
Prometheus
```

### Grafana

Provides:

* dashboards
* visualization
* alerting
* trace exploration
* log exploration

### Loki

Stores structured logs.

Flow:

```text
Application
   |
Fluent Bit
   |
OTEL Collector
   |
Loki
   |
Grafana
```

### Tempo

Stores distributed traces.

Flow:

```text
Application
   |
OTLP
   |
OTEL Collector
   |
Tempo
   |
Grafana
```

## Logging

### Structured Logging

Every service emits JSON logs.

Examples:

Node:

* Winston

Go:

* Zap

Python:

* Structlog

Fields:

* timestamp
* service
* level
* traceId
* spanId
* requestId
* userId

### Correlation

Logs contain trace identifiers.

A request can be followed across:

* API Gateway
* Auth
* User
* Payment
* Order
* Notification

## Metrics

Exposed through:

```text
/metrics
```

Collected metrics:

* request count
* latency
* error rate
* active connections
* Kafka consumer lag
* Redis operations
* database queries

### ServiceMonitor

Each service exposes a ServiceMonitor resource.

Prometheus automatically discovers metrics endpoints.

## Tracing

Distributed tracing uses **W3C Trace Context**.

Context propagation:

* HTTP
* gRPC
* Kafka

Example trace:

```text
Client
 |
API Gateway
 |
Auth
 |
Redis
 |
PostgreSQL
```

Grafana Tempo visualizes the complete request.

## Dashboards

Grafana dashboards include:

### Application

* Requests/sec
* Latency
* Error rate
* Success rate

### Infrastructure

* CPU
* Memory
* Disk
* Network

### Kubernetes

* Pod status
* Deployment health
* HPA activity
* Node utilization

### Kafka

* Consumer lag
* Throughput
* Broker health

### Databases

* Connection count
* Query latency
* Cache hit ratio

## Alerting

Alertmanager handles notifications.

Examples:

* PodCrashLooping
* HighLatency
* HighErrorRate
* NodeNotReady
* KafkaConsumerLag
* LowDiskSpace

Notifications:

* Slack
* Email
* Webhooks

## Benefits

The observability stack enables:

* Root cause analysis
* Performance tuning
* Capacity planning
* Incident response
* SLO monitoring
* Distributed debugging

---

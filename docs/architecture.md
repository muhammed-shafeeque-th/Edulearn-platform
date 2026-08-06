
# Edulearn Architecture

## Overview

Edulearn is a production-grade cloud-native learning platform built using **microservices architecture**, **Clean Architecture**, **SOLID principles**, and a **GitOps-based deployment model**.

The platform is designed to demonstrate how a real-world distributed system can be built using modern backend engineering and platform engineering practices.

## System Architecture

![Architecture](images/edulearn-arch-dark.png)

The platform consists of multiple independently deployable services that communicate internally using **gRPC** and **Kafka**, while external traffic is routed through **AWS Gateway API** backed by **AWS Application Load Balancer**.

## Architectural Principles

### Microservices

Each service owns a specific business capability and can be developed, tested, deployed, and scaled independently.

### Clean Architecture

Every application follows a layered architecture.

```text
Presentation Layer
        |
Application Layer
        |
Domain Layer
        |
Infrastructure Layer
```

#### Presentation

* HTTP Controllers
* gRPC Controllers
* WebSocket Gateways
* DTOs
* Validation

#### Application

* Use cases
* Commands
* Queries
* Business workflows

#### Domain

* Entities
* Value objects
* Repository interfaces
* Domain services

#### Infrastructure

* Database implementations
* Kafka adapters
* Redis adapters
* External API clients
* File storage providers

### SOLID Principles

The services are designed with:

* Single Responsibility Principle
* Open/Closed Principle
* Liskov Substitution Principle
* Interface Segregation Principle
* Dependency Inversion Principle

Dependency injection is implemented using:

* InversifyJS
* NestJS DI
* FastAPI dependency injection
* Go interfaces

## Service Architecture

### API Gateway

Responsibilities:

* HTTP API
* Authentication middleware
* Request validation
* File upload
* S3 presigned URLs
* Cloudinary integration
* gRPC request routing
* Trace propagation
* Metrics and logging

Technology:

* TypeScript
* Express
* gRPC
* InversifyJS

### Auth Service

Responsibilities:

* Authentication
* JWT issuance
* Refresh tokens
* Google OAuth
* Provider strategy pattern
* Session management

Technology:

* TypeScript
* Node.js
* PostgreSQL
* Redis
* Kafka

### User Service

Responsibilities:

* User profile management
* Account information
* Avatar metadata
* Preferences

Technology:

* TypeScript
* NestJS
* PostgreSQL
* Redis
* Kafka

### Course Service

Responsibilities:

* Course management
* Categories
* Instructors
* Pricing
* Enrollment metadata

Technology:

* TypeScript
* NestJS
* PostgreSQL
* Redis
* Kafka

### Payment Service

Responsibilities:

* Payment orchestration
* Stripe integration
* Razorpay integration
* Idempotency
* Payment strategy pattern

Technology:

* TypeScript
* NestJS
* PostgreSQL
* Redis
* Kafka

### Order Service

Responsibilities:

* Order lifecycle
* Checkout orchestration
* Payment coordination
* Enrollment generation

Technology:

* Python
* FastAPI
* PostgreSQL
* AsyncPG
* Kafka

### Notification Service

Responsibilities:

* Email notifications
* Event-driven notifications
* Delivery tracking

Technology:

* Go
* gRPC
* PostgreSQL
* GORM
* Kafka

### Chat Service

Responsibilities:

* Real-time messaging
* WebSocket communication
* Chat persistence

Technology:

* TypeScript
* NestJS
* MongoDB
* Redis
* Kafka

## Communication Patterns

### Synchronous Communication

Internal synchronous requests use **gRPC**.

Examples:

* API Gateway → Auth Service
* API Gateway → User Service
* Order Service → Payment Service

Benefits:

* Binary protocol
* Strong contracts
* Low latency
* Efficient serialization

### Asynchronous Communication

Domain events are published through **Kafka**.

Examples:

* UserRegistered
* OrderCreated
* PaymentCompleted
* CoursePurchased

Benefits:

* Loose coupling
* Event-driven workflows
* Independent consumers
* Retry capability

## Data Architecture

### PostgreSQL

Used by:

* Auth
* User
* Course
* Payment
* Order
* Notification

### MongoDB

Used by:

* Chat

### Redis

Used for:

* Caching
* Sessions
* Rate limiting
* Idempotency
* Temporary state

### Kafka

Used for:

* Domain events
* Notification workflows
* Payment events
* Enrollment events

## Shared Libraries

### @edulearn/core

Provides:

* Winston logging
* Prometheus metrics
* OpenTelemetry tracing
* Redis utilities
* Shared abstractions

### @edulearn/nest

Provides:

* NestJS modules
* Interceptors
* Health checks
* gRPC utilities
* Shared infrastructure components

## Request Flow

```text
Client
   |
AWS ALB
   |
Gateway API
   |
API Gateway
   |
gRPC
   |
Service
   |
Database / Redis / Kafka
```

Distributed trace context is propagated through every layer.

---

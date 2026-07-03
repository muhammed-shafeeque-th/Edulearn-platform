# EduLearn Platform

A comprehensive microservices-based e-learning platform built with modern technologies and best practices.

## 📚 Documentation

- **[Architecture Documentation](./ARCHITECTURE.md)** - Complete high-level architecture design, service details, communication patterns, and technology stack
- **[Service Documentation](./service-name/README.md)** - Individual service documentation

## 🏗️ Platform Overview

EduLearn is a scalable, event-driven microservices platform for delivering online educational content. The platform supports course management, user enrollment, payments, live sessions, real-time notifications, and comprehensive analytics.

### Key Features

- **Course Management**: Complete course lifecycle with sections, lessons, quizzes, and certificates
- **User Management**: User profiles, instructor management, carts, wishlists, and wallets
- **Payment Processing**: Multi-provider payment integration (Stripe, PayPal, Razorpay)
- **Order Management**: Order processing with lifecycle management
- **Live Sessions**: WebRTC-based video conferencing for live educational sessions
- **Real-time Notifications**: In-app, email, and push notifications
- **Analytics**: Comprehensive analytics and reporting
- **Chat**: Real-time messaging for course discussions

## 🎯 Services

| Service | Description | Technology |
|---------|-------------|------------|
| **API Gateway** | Single entry point, authentication, routing | Express.js, TypeScript |
| **Auth Service** | Authentication, authorization, OTP, OAuth | NestJS, TypeScript |
| **User Service** | User profiles, carts, wishlists, wallets | NestJS, TypeScript |
| **Course Service** | Course management, enrollments, progress | NestJS, TypeScript |
| **Order Service** | Order processing, lifecycle management | FastAPI, Python |
| **Payment Service** | Payment processing, multi-provider support | NestJS, TypeScript |
| **Notification Service** | Notifications, email, OTP, real-time | Go |
| **Session Service** | Live sessions, WebRTC video conferencing | Express.js, TypeScript |
| **Chat Service** | Real-time messaging | NestJS, TypeScript |
| **Analytics Service** | Data aggregation and analytics | FastAPI, Python |

## 🛠️ Technology Stack

### Backend
- **Languages**: TypeScript, Python, Go
- **Frameworks**: NestJS, Express.js, FastAPI
- **Databases**: PostgreSQL (with TypeORM, SQLAlchemy, GORM)
- **Cache**: Redis
- **Message Broker**: Apache Kafka
- **Communication**: gRPC, HTTP/HTTPS, WebSocket

### Infrastructure
- **Observability**: OpenTelemetry, Prometheus, Loki, Jaeger
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **Media Storage**: Cloudinary, AWS S3
- **Payment Providers**: Stripe, PayPal, Razorpay

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18+ (for TypeScript services)
- **Python** 3.11+ (for Python services)
- **Go** 1.21+ (for Go services)
- **PostgreSQL** 15+
- **Redis** 7+
- **Kafka** 3+ (optional for local development)
- **Docker** & **Docker Compose** (recommended)

### Running Services Locally

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd EduLearn
   ```

2. **Start infrastructure services** (PostgreSQL, Redis, Kafka)
   ```bash
   docker-compose -f docker-compose.edulearn.yml up -d
   ```

3. **Start individual services**
   ```bash
   # API Gateway
   cd api-gateway && npm install && npm run dev

   # Auth Service
   cd auth && npm install && npm run start:dev

   # User Service
   cd user && npm install && npm run start:dev

   # Course Service
   cd course && npm install && npm run start:dev

   # Order Service
   cd order && pip install -r requirements.txt && uvicorn src.main:app --reload

   # Payment Service
   cd payment && npm install && npm run start:dev

   # Notification Service
   cd notification && go mod download && go run cmd/main.go

   # Session Service
   cd session && npm install && npm run dev

   # Chat Service
   cd chat && npm install && npm run start:dev
   ```

### Environment Configuration

Each service has an `env.example` file. Copy and configure:

```bash
# Example for Auth Service
cd auth
cp env.example .env
# Edit .env with your configuration
```

Key environment variables:
- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string
- `KAFKA_BROKERS`: Kafka broker list
- `JWT_SECRET`: JWT signing secret
- Service-specific configuration (see service README files)

## 📖 Architecture

For detailed architecture documentation, see [ARCHITECTURE.md](./ARCHITECTURE.md).

### High-Level Architecture

```
┌─────────────┐
│   Clients   │ (Next.js Web, Mobile Apps)
└──────┬──────┘
       │ HTTP/HTTPS
┌──────▼─────────────────────────────────────┐
│         API Gateway                        │ (Express.js)
└──────┬─────────────────────────────────────┘
       │ gRPC
   ┌───┴───────────────────────────────────────┐
   │                                            │
   │  ┌──────────┐  ┌──────────┐  ┌──────────┐│
   │  │   Auth   │  │   User   │  │  Course  ││
   │  └──────────┘  └──────────┘  └──────────┘│
   │                                            │
   │  ┌──────────┐  ┌──────────┐  ┌──────────┐│
   │  │  Order   │  │ Payment  │  │Notify    ││
   │  └──────────┘  └──────────┘  └──────────┘│
   │                                            │
   │  ┌──────────┐  ┌──────────┐              │
   │  │ Session  │  │   Chat   │              │
   │  └──────────┘  └──────────┘              │
   └───────────────────────────────────────────┘
       │
       │ Kafka (Event-Driven)
       │
   ┌───▼───────────────────────────────────────┐
   │      Infrastructure Layer                 │
   │  PostgreSQL | Redis | Kafka | Observability│
   └───────────────────────────────────────────┘
```

### Communication Patterns

- **Synchronous**: gRPC for real-time, low-latency service-to-service communication
- **Asynchronous**: Kafka for event-driven, decoupled communication
- **Real-time**: WebSocket for live updates (notifications, chat, sessions)

## 🧪 Testing

Each service has its own test suite:

```bash
# Run tests for a service
cd <service-name>
npm test          # Node.js services
pytest            # Python services
go test ./...     # Go services
```

## 📊 Monitoring & Observability

### Metrics
- **Prometheus**: Metrics collection at `/metrics` endpoint
- **Grafana**: Visualization and dashboards

### Logging
- **Loki**: Centralized log aggregation
- **Structured Logging**: JSON format with correlation IDs

### Tracing
- **Jaeger**: Distributed tracing
- **OpenTelemetry**: Instrumentation

Access observability stack:
- Grafana: `http://localhost:3000`
- Prometheus: `http://localhost:9090`
- Jaeger: `http://localhost:16686`
- Loki: `http://localhost:3100`

## 🐳 Docker Deployment

### Build and Run with Docker Compose

```bash
docker-compose -f docker-compose.edulearn.yml up -d
```

### Individual Service Docker

Each service has a `Dockerfile`. Build and run:

```bash
cd <service-name>
docker build -t edulearn/<service-name>:latest .
docker run -p <port>:<port> edulearn/<service-name>:latest
```

## ☸️ Kubernetes Deployment

Kubernetes deployment manifests are in the `k8s/` directory:

```bash
kubectl apply -f k8s/
```

See individual service documentation for service-specific deployment instructions.

## 🔐 Security

- **Authentication**: JWT-based authentication with refresh tokens
- **Authorization**: Role-based access control (RBAC)
- **Rate Limiting**: Redis-based rate limiting at API Gateway
- **Input Validation**: Comprehensive validation at all layers
- **Webhook Security**: Signature verification for payment provider webhooks
- **Encryption**: TLS/SSL for all connections, encryption at rest

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow service-specific code style and architecture patterns
- Write comprehensive tests (unit, integration, e2e)
- Update documentation for any changes
- Follow Clean Architecture and SOLID principles
- Ensure all services pass linting and type checking

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🆘 Support

For questions and support:
- Check service-specific README files in each service directory
- Review [ARCHITECTURE.md](./ARCHITECTURE.md) for architectural questions
- Open an issue on GitHub

## 🔗 Service Documentation Links

- [API Gateway](./api-gateway/README.md)
- [Auth Service](./auth/README.md)
- [User Service](./user/README.md)
- [Course Service](./course/README.md)
- [Order Service](./order/README.md)
- [Payment Service](./payment/README.md)
- [Notification Service](./notification/README.md)
- [Session Service](./session/README.md)
- [Chat Service](./chat/README.md)

---

**Built with ❤️ by the EduLearn Team**


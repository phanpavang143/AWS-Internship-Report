---
title: "E-commerce Website on AWS"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# E-commerce Website on AWS
## Architecture, implementation, cost optimization, and deployment roadmap

### 1. Executive Summary

This project builds a scalable and secure e-commerce website on AWS using Spring Boot 3.5, Java 25, Spring MVC, and JSP for server-side rendering. The application uses Spring Security for `USER` and `ADMIN` authorization, Hibernate/JPA with MySQL for persistence, and Docker containers deployed on Amazon ECS Fargate. Amazon S3 is used for product images, while Amazon SQS supports asynchronous event processing. CloudWatch, CloudTrail, and Terraform provide observability, auditing, and Infrastructure as Code. The proposed architecture focuses on availability, security, cost optimization, operational simplicity, and a clear path for future scalability.

---

### 2. Problem Statement

#### 2.1. Current Issues

##### 1. Infrastructure and database management

The database is currently provided outside Terraform, so the infrastructure is not completely reproducible through Infrastructure as Code. This creates additional manual work when creating, restoring, or replicating environments. A managed Amazon RDS database should be provisioned through Terraform with a private subnet group, security group, backup policy, and secret management.

##### 2. Database connection management

The current `DriverManagerDataSource` does not provide a connection pool, which is not ideal when multiple ECS tasks access the same database. As the service scales horizontally, excessive connection creation and closure can increase latency and put pressure on MySQL. HikariCP should be introduced through the standard Spring Boot datasource configuration, with pool limits sized against the RDS connection capacity.

##### 3. Session and shopping-cart management

The shopping cart is currently stored in `HttpSession`, which creates a dependency on the ECS task serving the request. With multiple tasks, sticky sessions or a shared session store would be required to maintain state consistently. For an e-commerce platform, storing the cart by `user_id` in the database is preferable because it preserves the cart across tasks and devices. Redis can be introduced later when shared session or caching requirements justify it.

##### 4. Event processing and production configuration

SQS currently receives product add/remove cart events but is not yet used for a complete order-processing workflow. The architecture should evolve toward an asynchronous order flow using SQS and a dedicated worker running on ECS or Lambda. In addition, `hibernate.hbm2ddl.auto=update` should not be used as the production schema-management strategy. Database migrations should instead be controlled with a tool such as Flyway or Liquibase.

#### 2.2. Proposed Solution

The proposed solution is a modular monolith running on Amazon ECS Fargate, backed by Amazon RDS for MySQL and Amazon S3/CloudFront for product images. HikariCP provides database connection pooling, while cart data is moved to the database or Redis when shared state is required. Amazon SQS decouples asynchronous order and event processing from the web request lifecycle. Terraform manages the infrastructure, while CloudWatch and CloudTrail provide monitoring, logging, and auditing.

##### The architecture is divided into 3 independent processing flows

**1. User Flow (Web Application)**  
Users access the application through CloudFront and the Application Load Balancer before reaching the Spring Boot ECS service. This flow handles registration, login, profile management, product browsing, categories, and shopping-cart operations. Business data is stored in RDS, while product images are delivered from S3 through CloudFront.

**2. Admin Flow (Management)**  
Administrators use the same application but are authorized through Spring Security with the `ADMIN` role. This flow manages products, categories, customers, and operational data. Administrative changes are persisted in RDS and application activity can be monitored through centralized logging.

**3. Order/Event Flow (Asynchronous Processing)**  
Long-running or asynchronous business events are published to Amazon SQS instead of blocking the main HTTP request. An ECS worker or Lambda consumes messages, performs background processing, and updates business state. Retry policies and a Dead-Letter Queue can isolate failed messages and improve reliability.

#### 2.3. Benefits and Return on Investment (ROI)

The proposed architecture reduces operational risk by moving the database to a managed service, introducing connection pooling, and removing the dependency of cart state on an individual ECS task. Infrastructure costs can be controlled through right-sized Fargate tasks, autoscaling, CloudWatch log retention, and VPC endpoints for suitable AWS services. The ROI should be measured through total cost of ownership, reduced manual operations, lower downtime, improved response time, and the ability to serve additional users without a complete redesign. For a low-traffic environment, the platform can start with a small configuration and scale according to actual metrics.

---

### 3. Solution Architecture

#### 3.1. Overall Architecture Diagram

![Overall AWS Architecture](/images/2-Proposal/Sodokientruc.png)

The target architecture consists of Browser clients accessing CloudFront and ALB, which route traffic to Spring Boot services running on ECS Fargate. ECS connects to RDS MySQL for transactional data, S3/CloudFront for product images, and SQS for asynchronous events. Redis is an optional shared session/cache layer. CloudWatch and CloudTrail provide observability and audit capabilities, while Terraform manages the infrastructure.

#### 3.2. Key Processing Flows

##### Flow 1 — User and Web Application

* **Request routing:** Browser requests reach CloudFront and then the Application Load Balancer before being distributed to healthy ECS tasks. This creates a unified entry point and enables horizontal scaling.
* **Business processing:** Spring MVC/JSP renders server-side pages while Spring Security handles authentication and authorization. Hibernate/JPA accesses RDS MySQL through a managed connection pool.
* **Product images:** Product images are uploaded to S3 and distributed through CloudFront. This separates object storage from the application container lifecycle and prevents image loss when ECS tasks are replaced.

##### Flow 2 — Admin Management

* **Authentication and authorization:** Administrators authenticate through Spring Security and must have the `ADMIN` role. Administrative endpoints are protected using method or URL-level authorization.
* **Data management:** Admin users can create, update, and delete products and categories and manage customer information. Changes are stored in RDS and application logs can be used for operational traceability.
* **Image management:** Product images are stored in S3 instead of the container filesystem. This approach is suitable for Fargate because containers can be replaced or scaled at any time.

##### Flow 3 — Asynchronous Order/Event Processing

* **Queue publishing:** Events that require background processing are published to SQS. The web request does not need to wait for the entire background workflow to complete.
* **Worker processing:** An ECS worker or Lambda consumes messages, executes the required business logic, and updates RDS. Failed messages can be retried and moved to a Dead-Letter Queue after the configured number of attempts.
* **Monitoring:** Processing results and errors are sent to CloudWatch. Queue depth, processing latency, and error rate can be used to create operational alarms.

#### 3.3. AWS Services Used

##### Amazon ECS Fargate

ECS Fargate runs the Spring Boot containers without requiring server management. The service can scale the number of running tasks according to workload and is suitable for containerized deployment.

##### Application Load Balancer (ALB)

ALB receives HTTP/HTTPS traffic and distributes requests across healthy ECS tasks. Health checks automatically prevent unhealthy tasks from receiving new requests.

##### Amazon RDS for MySQL

RDS provides managed MySQL with automated backups, monitoring, and availability options. The database should be deployed in private subnets with a security group that only permits access from the ECS application layer.

##### Amazon S3

S3 stores product images and other static objects with high durability. Object storage is independent of container lifecycle and therefore works well with horizontally scaled ECS services.

##### Amazon CloudFront

CloudFront distributes cacheable content through edge locations. Combining CloudFront with S3 improves image delivery latency and reduces direct load on the application.

##### Amazon SQS

SQS provides a durable message queue for asynchronous events and background jobs. It decouples the web application from worker processing and supports retry-based reliability.

##### Amazon ElastiCache for Redis

Redis can provide shared session storage and application caching. For a development or low-traffic environment, it can remain optional until measurable performance or session requirements justify the additional cost.

##### Amazon CloudWatch

CloudWatch collects application and infrastructure logs, metrics, and alarms. It can monitor CPU, memory, latency, error rate, and SQS queue depth.

##### AWS CloudTrail

CloudTrail records AWS API activity and resource changes. Audit logs support security investigations, compliance controls, and operational accountability.

##### AWS Lambda

Lambda can consume SQS messages without requiring a continuously running worker service. It is suitable for short, intermittent background workloads.

##### NAT Gateway and VPC Endpoints

A NAT Gateway provides outbound connectivity from private subnets but introduces fixed and data-processing costs. Gateway or interface VPC endpoints can keep suitable AWS service traffic inside the AWS network and reduce unnecessary NAT usage.

##### Terraform

Terraform defines AWS networking, ECS, RDS, IAM, S3, SQS, and related resources as version-controlled Infrastructure as Code. This makes environments reproducible, reviewable, and easier to maintain.

---

### 4. Implementation

#### 4.1. Implementation Phases

##### Phase 1 — Application and Infrastructure Foundation

* Migrate the datasource configuration to HikariCP, remove production dependence on `hibernate.hbm2ddl.auto=update`, and externalize configuration through environment variables and secrets.
* Provision RDS MySQL, S3, SQS, ECS, IAM, networking, and security groups using Terraform.

##### Phase 2 — Stateless Architecture and Horizontal Scaling

* Move the shopping cart from local `HttpSession` to database-backed storage or Redis so that any ECS task can serve a request.
* Configure ECS services, ALB health checks, desired task count, and autoscaling policies.

##### Phase 3 — Performance and Cost Optimization

* Deliver product images through S3 and CloudFront and use VPC endpoints for S3/SQS where appropriate.
* Configure CloudWatch alarms and log retention and right-size Fargate and RDS resources based on measured traffic.

##### Phase 4 — Business Workflow Expansion

* Complete the order workflow and introduce asynchronous processing through SQS and a worker.
* Introduce separate Order, Inventory, or Search services only when metrics demonstrate a need for independent scaling, ownership, or deployment lifecycle.

#### 4.2. Technical and Security Requirements

##### 1. Identity and Authorization

Spring Security must clearly separate `USER` and `ADMIN` permissions, while IAM roles should follow the principle of least privilege. AWS access keys and database credentials must never be hard-coded in the application source code.

##### 2. Data Protection

RDS should be deployed in private subnets and accept connections only from the ECS security group. Secrets should be managed through AWS Secrets Manager, and application traffic should use HTTPS/TLS.

##### 3. Performance Optimization

HikariCP must be sized according to the number of ECS tasks and the maximum RDS connection capacity. Caching should be introduced after metrics demonstrate that database access or request latency is a meaningful bottleneck.

##### 4. Monitoring and Logging

CloudWatch should centralize application logs, infrastructure metrics, and alarms, while CloudTrail should provide AWS API auditing. Logs must not expose passwords, session identifiers, access tokens, or other sensitive user information.

---

### 5. Deployment Roadmap and Milestones

| Milestone | Expected Timeline | Main Deliverable |
|---|---|---|
| M1 — Foundation | Weeks 1–2 | Spring Boot, HikariCP, Docker, and Terraform baseline |
| M2 — Managed Database | Weeks 3–4 | RDS MySQL, Secrets Manager, and private networking |
| M3 — Production-ready ECS | Weeks 5–6 | ECS Fargate, ALB, health checks, and autoscaling |
| M4 — Storage & Async | Weeks 7–8 | S3/CloudFront, SQS, and background worker |
| M5 — Observability | Weeks 9–10 | CloudWatch, CloudTrail, alarms, and log retention |
| M6 — Optimization & Review | Weeks 11–12 | Load testing, cost review, security review, and documentation |
| M7 — Future Scaling | After Month 8 | Redis, read replica, or service separation based on metrics |

---

### 6. Estimated Budget

> The following figures are **indicative estimates** for a small/demo or small-production environment, not fixed AWS quotations. Actual costs depend on AWS Region, instance type, traffic, storage, requests, backups, and runtime.

| AWS Service | Estimated Configuration / Scale | Estimated Cost / Month (USD) |
|---|---|---:|
| ECS Fargate | Web + Worker, approximately 2 small tasks | ~20–80 |
| RDS MySQL | Small Single-AZ instance | ~20–50 |
| S3 + CloudFront | ~50 GB storage, low traffic | ~10–30 |
| SQS | Approximately 1M requests/month | ~1–5 |
| ElastiCache Redis | Small node, optional | ~15–40 |
| CloudWatch + CloudTrail | Small-scale logs and metrics | ~10–25 |
| NAT Gateway | 1 NAT Gateway | ~45–60+ |
| **Total Reference Range** | Small environment, low traffic | **~121–290+** |

For development or demo environments, costs can be reduced by running one ECS task, selecting a small RDS instance, retaining CloudWatch logs for a short period such as seven days, avoiding Redis until it is needed, and shutting down non-production environments outside working hours.

---

### 7. Risk Assessment

#### 7.1. Risk Matrix and Mitigation Strategy

| Potential Risk | Impact Level | Probability | Mitigation Strategy |
|---|---|---|---|
| RDS overload or connection exhaustion | High | Medium | HikariCP, connection limits, RDS monitoring, and load testing |
| Data loss or backup failure | High | Low | Automated backups, suitable retention, and regular restore testing |
| Session/cart inconsistency during scaling | High | Medium | Database-backed cart or shared Redis session |
| Unexpected NAT Gateway cost | Medium | Medium | VPC endpoints, traffic monitoring, and AWS cost alerts |
| ECS task failure during traffic spikes | High | Medium | ALB health checks, autoscaling, and CloudWatch alarms |
| Secret or credential exposure | Very High | Low | Secrets Manager, least-privilege IAM, and no hard-coded secrets |
| SQS message processing failure | Medium | Medium | Retry policy, visibility timeout, and Dead-Letter Queue |
| Uncontrolled production schema changes | High | Medium | Flyway/Liquibase migrations instead of `hbm2ddl.auto=update` |
| Premature microservice adoption | Medium | Medium | Keep modular monolith and use metrics to justify service separation |

---

### 8. Expected Outcomes

#### 8.1. Technical Breakthrough

The architecture moves the application from manually managed dependencies toward a managed, stateless, and horizontally scalable platform. ECS Fargate, RDS, S3, SQS, and CloudWatch establish clear infrastructure responsibilities and reduce dependence on manually operated servers. Standardized Terraform, connection pooling, asynchronous processing, and observability provide a foundation for future growth without requiring a complete architectural rewrite.

#### 8.2. Comprehensive Cost Optimization

Costs are controlled by right-sizing Fargate and RDS resources according to actual workload, limiting log retention, and avoiding Redis or advanced services until they are justified. VPC endpoints can reduce unnecessary NAT Gateway traffic for supported AWS services. Autoscaling allows the platform to add capacity when demand increases instead of maintaining an oversized fixed environment.

#### 8.3. Long-Term Value

The architecture provides a foundation for increasing users, products, and transactions while keeping operational complexity manageable. As the platform grows, Redis, RDS read replicas, dedicated workers, or a search service can be introduced without replacing the entire application architecture. The modular monolith approach also allows the project to move quickly during early development and introduce additional operational complexity only when measurable business or technical requirements justify it.

---

# Conclusion

The recommended target architecture is a **Spring Boot modular monolith running on ECS Fargate, with Amazon RDS for MySQL as the primary database, S3/CloudFront for product images, SQS for asynchronous processing, and CloudWatch/CloudTrail for observability and auditing**. Redis should be treated as an optional component for shared sessions or caching rather than a mandatory dependency from the beginning. Microservices should be introduced only when independent scaling, team ownership, deployment lifecycle, or measured bottlenecks justify the additional operational complexity. A phased implementation provides a practical balance between scalability, security, operational simplicity, and cost.

## Appendix — Architecture Principles

1. **Managed first:** Prefer RDS, S3, SQS, and Fargate over self-managed infrastructure.
2. **Stateless first:** ECS tasks should not hold critical business state in local filesystems or local sessions.
3. **Scale from evidence:** Introduce Redis, read replicas, or microservices only when metrics demonstrate a need.
4. **Security by default:** Use private subnets, least-privilege IAM, Secrets Manager, HTTPS, and audit logging.
5. **Infrastructure as Code:** Terraform should remain the standard source of truth for AWS infrastructure.

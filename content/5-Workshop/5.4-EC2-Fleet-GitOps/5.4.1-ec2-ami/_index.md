---
title: "RDS MySQL and connection pooling"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.4.1. </b> "
---

## Step 1: Create RDS MySQL
● Go to AWS Console → RDS → Databases → Create database.
● Select MySQL.
● Configure the Database name, Username, and Password.
● Select a Private Subnet.
● Configure the RDS Security Group to allow traffic only on port 3306 from ECS-SG.
ECS Fargate ──3306──> RDS MySQL
![AWS Illustration](/images/5-Workshop/5.4-S3-onprem/Pooling.jpg)

## Step 2: Configure Spring Boot connection
In application.properties:
spring.datasource.url=jdbc:mysql://DBHOST:3306/webdemospring.datasource.username={DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

## Step 3: Configure HikariCP
Spring Boot uses HikariCP as the default Connection Pool.
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=2
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000

## Step 4: Connection Pooling Mechanism

## HikariCP maintains a pool of connections:
                Spring Boot
                     │
              ┌──────▼──────┐
              │   HikariCP  │
              │ Connection  │
              │    Pool     │
              └──────┬──────┘
                     │
            ┌────────┼────────┐
            ▼        ▼        ▼
         Conn 1   Conn 2   Conn 3
            └────────┼────────┘
                     ▼
                  RDS MySQL

After use, connections are returned to the pool so they can be reused by subsequent requests.

## Step 5: Monitoring and Optimization
Monitor:
● Number of connections on RDS.
● RDS CPU and Memory usage.
● Application response time.
● Number of concurrently running ECS ​​Tasks.
● HikariCP active/idle connections.
In particular, when using multiple ECS Tasks, calculate the aggregate connection pool size across all tasks to avoid exceeding RDS connection limits.

## Result:
RDS MySQL handles centralized data storage, while HikariCP manages and reuses database connections. This implementation reduces connection creation overhead and is well-suited for the Spring Boot + ECS Fargate + RDS MySQL architecture.

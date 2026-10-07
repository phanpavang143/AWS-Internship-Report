---
title: "RDS, Redis and S3"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.6.2. </b> "
---

## Step 1: Create RDS MySQL
Go to: AWS Console → RDS → Databases → Create database
Configuration:
● Engine: MySQL
● DB identifier: webdemo-db
● Username: admin
● Password: [set your own]
● VPC: select the system's VPC
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/CRMySQL.jpg)

ECS Fargate
     │
     │ JDBC
     ▼
┌──────────────┐
│ RDS MySQL    │
│ webdemo-db   │
└──────────────┘

## Step 2: Connect ECS to RDS
In the RDS Security Group, allow: Inbound
Type: MySQL
Port: 3306
Source: ECS Security Group
ECS
 │
 │ Port 3306
 ▼
RDS MySQL

## Step 3: Create Redis
Go to: AWS Console → ElastiCache → Redis → Create
Configuration:
● Name: webdemo-redis
● Engine: Redis
● VPC: Select the system's VPC
ECS Fargate
     │
     ├──────────────► RDS MySQL
     │
     └──────────────► Redis
                         │
                         ▼
                    Session / Cache
## Step 4: Create S3 Bucket
Go to: AWS Console → S3 → Create bucket
Create: webdemo-product-images
Settings:
● Block Public Access: Enabled
● Versioning: Optional (based on requirements)
● Region: ap-southeast-1
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/CRBucket.jpg)
ECS / Spring Boot
       │
       │ Upload Image
       ▼
┌──────────────────┐
│ S3 Bucket        │
│ Product Images   │
└──────────────────┘

## Step 5: Upload product images to S3
When the Admin uploads a product:
Admin
  │
  ▼
Spring Boot
  │
  ├── Product information → RDS
  │
  └── Product image ──────► S3
Overall Architecture
                    ECS Fargate
                   /       │    \
                  /        │     \
                 ▼      ▼         ▼
          ┌─────────┐ ┌───────┐ ┌──────────────┐
          │RDS MySQL│ │ Redis │ │ S3           │
          │ Database│ │ Cache │ │ Product Image│
          └─────────┘ └───────┘ └──────────────┘

## Result:
RDS MySQL stores business data, Redis supports shared sessions/caching, and S3 stores product images. These three services are integrated with ECS Fargate to build a scalable WebDemo system that decouples data from the application.
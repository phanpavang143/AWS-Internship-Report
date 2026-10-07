---
title: "Amazon RDS MySQL, Amazon S3, CloudFront and ElastiCache Redis"
date: 2026-08-30
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

## Step 1: Create an Amazon RDS MySQL instance
● Go to AWS Console → RDS → Databases → Create database.
● Select MySQL.
● Set the Database name, Username, and Password.
● Place the RDS instance in a private subnet.
● Configure the Security Group to allow traffic only on port 3306 from ECS-SG.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/RDSMySQL.jpg)
ECS Fargate ──3306──> RDS MySQL

## Step 2: Create Amazon S3
● Go to S3 → Create bucket.
● Create a bucket to store product images: `webdemo-product-images`.
● Do not enable public access directly on the bucket.
● ECS uses an IAM Role to upload/download images.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/S3.jpg)
ECS Fargate ──> S3 Product Images

## Step 3: Configure CloudFront
● Go to CloudFront → Create distribution.
● Select the S3 bucket as the Origin.
● Use the CloudFront URL to distribute images.
● Configure HTTPS and the appropriate Cache Policy.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/CloudFront.jpg)
Traffic flow:
User → CloudFront → S3

## Step 4: Create ElastiCache Redis
● Go to ElastiCache → Redis → Create.
● Place the Redis instance in a private subnet.
● Configure the security group for Redis.
● Allow only ECS-SG to access Redis on port 6379.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/Redis.jpg)
ECS Fargate ──6379──> ElastiCache Redis

## Step 5: Application Integration
The Spring Boot application connects to:
MySQL      → Business data
S3         → Product images
Redis      → Cache data
CloudFront → Image distribution
When a user requests a product image, the content can be served via CloudFront instead of accessing S3 directly every time.

## Overall Architecture
                   Internet
                       │
                       ▼
                  CloudFront
                       │
                       ▼
                      S3
                 Product Images

                       │
                       ▼
                     ALB
                       │
                       ▼
                ECS Fargate
                 /    |     \
                /     |      \
               ▼      ▼       ▼
          RDS MySQL  Redis    SQS
                    ElastiCache

## Outcome:
RDS handles relational data, S3 stores images, CloudFront improves content delivery efficiency, and Redis offloads the RDS instance through caching. Data services such as RDS and Redis are placed in a private subnet, allowing access only from ECS via Security Groups.
---
title: "ECS, ALB and CloudFront"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.6.1. </b> "
---

## Step 1: Create ECS Cluster
Go to: AWS Console → ECS → Clusters → Create cluster
Create: Name: webdemo-cluster
     Infrastructure: AWS Fargate
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/CCluster.jpg)
AWS Console
     │
     ▼
    ECS
     │
     ▼
Create Cluster
     │
     ▼
webdemo-cluster

## Step 2: Create ECS Service
Go to: ECS → Cluster → Create service
Configuration:
●Launch type: Fargate
●Container: webdemo
●Desired tasks: 1
●Container port: 8080
ECS Cluster
     │
     ▼
ECS Service
     │
     ▼
Fargate Task
     │
     ▼
Spring Boot :8080

## Step 3: Create Application Load Balancer
Go to: EC2 → Load Balancers → Create Load Balancer → Application Load Balancer
Configuration:
●Name: webdemo-alb
●Scheme: Internet-facing
●Listener: HTTP :80
●Target: ECS Service
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/ECSService.jpg)
User
   │
  ▼
ALB :80
  │
  ▼
Target Group
  │
  ▼
ECS Fargate :8080

## Step 4: Check Health Check
Go to: EC2 → Target Groups → webdemo-target-group → Targets
Check status:
ECS Task
   │
   ▼
Health Check
   │
   ├── Healthy ✓
   │
   └── Unhealthy ✗
## Step 5: Create CloudFront Distribution
Go to: AWS Console → CloudFront → Create distribution
Select:
● Origin: ALB
● Protocol: HTTP/HTTPS
● Viewer protocol: Redirect HTTP to HTTPS
User
  │
  ▼
CloudFront
  │
  ▼
ALB
  │
  ▼
ECS Fargate
  │
  ▼
Spring Boot

## Step 6: Verify CloudFront
Once the Distribution status changes to: Enabled
Get the: CloudFront Domain Name
Access the domain to verify the website.

Browser
   │
   ▼
CloudFront
   │
   ├── Cache
   │
   ▼
ALB
   │
   ▼
ECS

## Result:
ECS Fargate runs the containerized Spring Boot application; the ALB distributes requests to ECS Tasks and performs health checks, while CloudFront provides a content delivery and caching layer in front of the system.

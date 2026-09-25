---
title: "Docker, Amazon ECS Fargate và Application Load Balancer"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---


Build image Spring Boot multi-stage, push lên ECR và chạy ECS Fargate. ALB route đến target group, health check /actuator/health và autoscaling theo CPU, memory hoặc request count.

![ECS Fargate và ALB](/images/2-Proposal/platform_architecture.jpeg)

## Kiểm tra

``bash
terraform fmt -check
terraform validate
terraform plan
``




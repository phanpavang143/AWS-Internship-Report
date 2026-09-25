---
title: "Docker, Amazon ECS Fargate and Application Load Balancer"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.3. </b> "
---


Build a multi-stage Spring Boot image, push it to ECR and run it on ECS Fargate. The ALB routes to a target group, checks /actuator/health and scales on CPU, memory or request count.

![ECS Fargate and ALB](/images/2-Proposal/platform_architecture.jpeg)

## Validation

``bash
terraform fmt -check
terraform validate
terraform plan
``




---
title: "Subnets, security groups and VPC endpoints"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.2.2. </b> "
---


The ALB receives Internet traffic; ECS only accepts the ALB; RDS/Redis only accept ECS. Use S3/SQS endpoints to reduce NAT.

![AWS illustration](/images/5-Workshop/5.3-S3-vpc/overview.png)

``bash
terraform validate
terraform plan
``




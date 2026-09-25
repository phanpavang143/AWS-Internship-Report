---
title: "Subnet, security group và VPC Endpoint"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.2.2. </b> "
---


ALB nhận Internet; ECS chỉ nhận từ ALB; RDS/Redis chỉ nhận từ ECS. Dùng endpoint cho S3/SQS để giảm NAT.

![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/overview.png)

``bash
terraform validate
terraform plan
``




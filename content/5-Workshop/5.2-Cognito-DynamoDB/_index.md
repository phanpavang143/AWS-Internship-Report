---
title: "5.2. Terraform, VPC, private subnets and network security"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.2. </b> "
---


Use a two-AZ VPC. Public subnets host the ALB/NAT Gateway; private subnets host ECS, RDS and Redis. Use S3 gateway and SQS interface endpoints when appropriate to reduce NAT cost.

![AWS VPC](/images/5-Workshop/5.3-S3-vpc/vpc.png)

## Validation

``bash
terraform fmt -check
terraform validate
terraform plan
``




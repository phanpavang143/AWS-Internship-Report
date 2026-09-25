---
title: "Terraform, VPC, private subnet và bảo mật mạng"
date: 2026-09-25
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---


Thiết kế VPC hai Availability Zone. Public subnet chứa ALB/NAT Gateway; private subnet chứa ECS, RDS và Redis. Dùng S3 Gateway Endpoint và SQS Interface Endpoint khi phù hợp để giảm chi phí NAT.

![VPC trên AWS](/images/5-Workshop/5.3-S3-vpc/vpc.png)

## Kiểm tra

``bash
terraform fmt -check
terraform validate
terraform plan
``




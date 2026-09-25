---
title: "AWS infrastructure cleanup and cost control"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.6. </b> "
---


Clean up in dependency order. Export required data, create an RDS snapshot and run terraform plan -destroy before destroy. Remove ECS/ALB/CloudFront, RDS/Redis/S3, SQS/Lambda and VPC endpoints/NAT Gateway; check Cost Explorer and orphaned resources last.

## Validation

``bash
terraform fmt -check
terraform validate
terraform plan
``




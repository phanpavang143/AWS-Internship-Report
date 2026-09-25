---
title: "5.4. Amazon RDS MySQL, Amazon S3, CloudFront and ElastiCache Redis"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.4. </b> "
---


RDS MySQL stores transactions with backups, encryption and HikariCP. S3 stores images and CloudFront distributes them. Redis provides shared sessions across ECS tasks. Enable S3 Block Public Access and least-privilege IAM.

## Validation

``bash
terraform fmt -check
terraform validate
terraform plan
``




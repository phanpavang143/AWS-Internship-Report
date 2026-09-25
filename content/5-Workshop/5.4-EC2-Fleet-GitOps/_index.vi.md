---
title: "5.4. Amazon RDS MySQL, Amazon S3, CloudFront và ElastiCache Redis"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.4. </b> "
---


RDS MySQL lưu giao dịch với backup, encryption và HikariCP. S3 lưu ảnh, CloudFront phân phối ảnh. Redis cung cấp session dùng chung cho nhiều ECS task. S3 bật Block Public Access và dùng IAM least privilege.

## Kiểm tra

``bash
terraform fmt -check
terraform validate
terraform plan
``




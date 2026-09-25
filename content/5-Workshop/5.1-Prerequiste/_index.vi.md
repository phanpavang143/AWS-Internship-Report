---
title: "Chuẩn bị môi trường, AWS Region và công cụ triển khai"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---


Cài Java 25, Maven, Docker, AWS CLI và Terraform. Dùng một Region thống nhất, ví dụ ap-southeast-1. Endpoint /actuator/health phải hoạt động. Lưu password RDS trong Secrets Manager/SSM, giữ RDS và Redis ở private subnet, tag resource với Project, Environment và ManagedBy=Terraform.

![AWS Region và VPC console](/images/5-Workshop/5.2-Prerequisite/region.png)

## Kiểm tra

``bash
terraform fmt -check
terraform validate
terraform plan
``




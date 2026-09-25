---
title: "Terraform backend và biến môi trường"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.2.1. </b> "
---


Tạo S3 backend có versioning; không lưu secret trong tfvars. Chạy init, validate và plan trước apply.

![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/overview.png)

``bash
terraform validate
terraform plan
``




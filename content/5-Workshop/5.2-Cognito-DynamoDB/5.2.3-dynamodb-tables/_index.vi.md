---
title: "State, output và secrets"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.2.3. </b> "
---


Output chỉ chứa ARN/endpoint không nhạy cảm. Đặt sensitive=true và tách Terraform role, ECS execution role, task role.

![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/overview.png)

``bash
terraform validate
terraform plan
``




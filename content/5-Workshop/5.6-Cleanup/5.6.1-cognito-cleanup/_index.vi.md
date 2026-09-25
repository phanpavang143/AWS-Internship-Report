---
title: "ECS, ALB và CloudFront"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.6.1. </b> "
---


Dừng hoặc scale service về 0, xóa ECS service/cluster, target group và listener ALB. Chỉ xóa CloudFront sau khi kiểm tra DNS và origin không còn phụ thuộc.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


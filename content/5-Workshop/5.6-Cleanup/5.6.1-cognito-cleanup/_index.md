---
title: "ECS, ALB and CloudFront"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.6.1. </b> "
---


Stop or scale the service to zero, then delete the ECS service/cluster, target group and ALB listener. Delete CloudFront only after checking DNS and origin dependencies.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


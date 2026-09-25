---
title: "VPC Endpoint và NAT Gateway"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.6.4. </b> "
---


Xóa workload trước, sau đó xóa interface endpoint, security group liên quan, NAT Gateway và Elastic IP không dùng.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


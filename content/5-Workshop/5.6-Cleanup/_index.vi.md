---
title: "Cleanup hạ tầng AWS và kiểm soát chi phí"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.6. </b> "
---


Cleanup theo thứ tự phụ thuộc. Export dữ liệu cần giữ, tạo RDS snapshot và chạy terraform plan -destroy trước khi destroy. Xóa ECS/ALB/CloudFront, RDS/Redis/S3, SQS/Lambda, VPC Endpoint/NAT Gateway; kiểm tra Cost Explorer và orphan resource sau cùng.

## Kiểm tra

``bash
terraform fmt -check
terraform validate
terraform plan
``




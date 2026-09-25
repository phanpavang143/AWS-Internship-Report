---
title: "RDS, Redis và S3"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.6.2. </b> "
---


Export dữ liệu cần giữ, tạo RDS snapshot, kiểm tra deletion protection. Xóa Redis, xóa toàn bộ version/delete marker trong S3 rồi mới xóa bucket.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


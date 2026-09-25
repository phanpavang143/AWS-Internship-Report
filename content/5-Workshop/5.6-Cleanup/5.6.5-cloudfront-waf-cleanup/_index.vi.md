---
title: "Terraform destroy an toàn và kiểm tra chi phí"
date: 2026-08-30
weight: 5
chapter: false
pre: " <b> 5.6.5. </b> "
---


Chạy terraform plan -destroy, review đúng workspace, tạo snapshot/backup rồi mới terraform destroy. Kiểm tra Cost Explorer, ECR image, Elastic IP, CloudWatch log và S3 còn sót.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


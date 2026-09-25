---
title: "SQS và Lambda"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.6.3. </b> "
---


Dừng producer, để consumer xử lý hết queue, kiểm tra DLQ. Sau đó xóa event source mapping, Lambda, queue và log group; giữ lại message cần điều tra.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


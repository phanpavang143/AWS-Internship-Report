---
title: "RDS, Redis and S3"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.6.2. </b> "
---


Export required data, create an RDS snapshot and check deletion protection. Delete Redis, remove all S3 versions/delete markers, then delete the bucket.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


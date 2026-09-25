---
title: "Safe Terraform destroy and cost verification"
date: 2026-08-30
weight: 5
chapter: false
pre: " <b> 5.6.5. </b> "
---


Run terraform plan -destroy, review the correct workspace, create snapshots/backups and then run terraform destroy. Check Cost Explorer, ECR images, Elastic IPs, CloudWatch logs and S3 leftovers.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


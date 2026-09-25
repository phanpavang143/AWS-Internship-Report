---
title: "SQS and Lambda"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.6.3. </b> "
---


Stop producers, let consumers drain the queue and inspect the DLQ. Then delete event source mappings, Lambda, queues and log groups; preserve messages needed for investigation.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


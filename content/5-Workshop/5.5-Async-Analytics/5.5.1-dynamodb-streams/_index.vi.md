---
title: "SQS và hàng đợi order"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.5.1. </b> "
---


Tạo queue chính và DLQ. Message có orderId, event type, version, correlation ID; consumer idempotent và có visibility timeout phù hợp.

![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/overview.png)

``bash
terraform validate
terraform plan
``




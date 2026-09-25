---
title: "SQS and the order queue"
date: 2026-09-25
weight: 1
chapter: false
pre: " <b> 5.5.1. </b> "
---


Create a main queue and DLQ. Messages contain orderId, event type, version and correlation ID; consumers are idempotent and use a suitable visibility timeout.

![AWS illustration](/images/5-Workshop/5.3-S3-vpc/overview.png)

``bash
terraform validate
terraform plan
``




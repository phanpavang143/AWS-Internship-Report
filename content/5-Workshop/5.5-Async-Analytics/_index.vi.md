---
title: "Amazon SQS, AWS Lambda, CloudWatch và CloudTrail"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.5. </b> "
---


Checkout ghi order rồi gửi event vào SQS. Worker ECS hoặc Lambda xử lý notification, inventory và retry; message phải idempotent và có dead-letter queue. CloudWatch thu log/metric, CloudTrail lưu audit API call.

## Kiểm tra

``bash
terraform fmt -check
terraform validate
terraform plan
``




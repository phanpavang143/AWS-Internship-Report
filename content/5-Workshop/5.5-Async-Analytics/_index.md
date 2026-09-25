---
title: "Amazon SQS, AWS Lambda, CloudWatch and CloudTrail"
date: 2026-08-30
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---


Checkout commits the order and publishes an SQS event. An ECS worker or Lambda handles notifications, inventory and retries; messages must be idempotent and use a dead-letter queue. CloudWatch collects logs/metrics and CloudTrail records API calls.

## Validation

``bash
terraform fmt -check
terraform validate
terraform plan
``




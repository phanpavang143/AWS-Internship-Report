---
title: "ALB health check và autoscaling"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.3.2. </b> "
---


Dùng /actuator/health, circuit breaker, minimum healthy percent và target tracking. CloudFront trỏ origin về ALB khi cần.

![Minh họa AWS](/images/2-Proposal/platform_architecture.jpeg)

``bash
terraform validate
terraform plan
``




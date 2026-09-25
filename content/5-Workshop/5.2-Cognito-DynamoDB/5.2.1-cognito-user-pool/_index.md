---
title: "Terraform backend and environment variables"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.2.1. </b> "
---


Create a versioned S3 backend; never store secrets in tfvars. Run init, validate and plan before apply.

![AWS illustration](/images/5-Workshop/5.3-S3-vpc/overview.png)

``bash
terraform validate
terraform plan
``




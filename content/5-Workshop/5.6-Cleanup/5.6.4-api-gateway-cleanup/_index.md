---
title: "VPC endpoints and NAT Gateway"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.6.4. </b> "
---


Remove workloads first, then delete interface endpoints, related security groups, NAT Gateways and unused Elastic IPs.

![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/delete-s3.png)

``bash
terraform plan -destroy
terraform destroy
``


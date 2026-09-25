---
title: "Environment, AWS Region and deployment tools"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---


Install Java 25, Maven, Docker, AWS CLI and Terraform. Use one Region consistently and expose /actuator/health. Store RDS passwords in Secrets Manager/SSM, keep RDS and Redis private, and tag resources with Project, Environment and ManagedBy=Terraform.

![AWS Region and VPC console](/images/5-Workshop/5.2-Prerequisite/region.png)

## Validation

``bash
terraform fmt -check
terraform validate
terraform plan
``




---
title: "Workshop: deploying the Spring Boot e-commerce website on AWS"
date: 2026-09-25
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

This workshop documents a Spring Boot 3.5, Java 25 and Spring MVC/JSP modular monolith. The Dockerized application runs on Amazon ECS Fargate behind an Application Load Balancer and Amazon CloudFront.

![E-commerce website architecture on AWS](/images/2-Proposal/Sodokientruc.png)

## Services

Amazon ECS Fargate, Application Load Balancer, Amazon RDS for MySQL, Amazon S3, Amazon CloudFront, Amazon SQS, Amazon ElastiCache for Redis, Amazon CloudWatch, AWS CloudTrail, AWS Lambda, AWS NAT Gateway, VPC endpoints and Terraform.

## Workshop path

1. [5.1. Environment, AWS Region and deployment tools](5.1-prerequiste/)
2. [5.2. Terraform, VPC, private subnets and network security](5.2-cognito-dynamodb/)
3. [5.3. Docker, Amazon ECS Fargate and Application Load Balancer](5.3-matchmaker-api/)
4. [5.4. Amazon RDS MySQL, Amazon S3, CloudFront and ElastiCache Redis](5.4-EC2-Fleet-GitOps/)
5. [5.5. Amazon SQS, AWS Lambda, CloudWatch and CloudTrail](5.5-Async-Analytics/)
6. [5.6. AWS infrastructure cleanup and cost control](5.6-Cleanup/)

Validate Terraform plans, ALB health, ECS connectivity to RDS/Redis, CloudFront image delivery, SQS consumption and CloudWatch logs after each step. Never commit credentials or a Terraform state containing secrets.





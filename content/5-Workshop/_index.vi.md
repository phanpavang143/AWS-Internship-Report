---
title: "Workshop: triển khai website thương mại điện tử Spring Boot trên AWS"
date: 2026-09-25
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

Workshop này mô tả triển khai website thương mại điện tử Spring Boot 3.5, Java 25, Spring MVC/JSP theo modular monolith. Ứng dụng được đóng gói Docker và chạy trên Amazon ECS Fargate, phía trước là Application Load Balancer và Amazon CloudFront.

[!NOTE]

Link Web Demo: https://phanpavang143.github.io/WebDemo/

Link Source Code: https://github.com/phanpavang143/WebDemo

![Kiến trúc website thương mại điện tử trên AWS](/images/2-Proposal/Sodokientruc.png)

## Dịch vụ sử dụng

Amazon ECS Fargate, Application Load Balancer, Amazon RDS for MySQL, Amazon S3, Amazon CloudFront, Amazon SQS, Amazon ElastiCache for Redis, Amazon CloudWatch, AWS CloudTrail, AWS Lambda, AWS NAT Gateway, VPC Endpoint và Terraform.

## Lộ trình workshop

1. [5.1. Chuẩn bị môi trường, AWS Region và công cụ triển khai](5.1-prerequiste/)
2. [5.2. Terraform, VPC, private subnet và bảo mật mạng](5.2-cognito-dynamodb/)
3. [5.3. Docker, Amazon ECS Fargate và Application Load Balancer](5.3-matchmaker-api/)
4. [5.4. Amazon RDS MySQL, Amazon S3, CloudFront và ElastiCache Redis](5.4-EC2-Fleet-GitOps/)
5. [5.5. Amazon SQS, AWS Lambda, CloudWatch và CloudTrail](5.5-Async-Analytics/)
6. [5.6. Cleanup hạ tầng AWS và kiểm soát chi phí](5.6-Cleanup/)

Kiểm tra sau mỗi bước: Terraform plan, ALB health check, kết nối ECS đến RDS/Redis, tải ảnh qua CloudFront, message SQS được xử lý và log xuất hiện trên CloudWatch. Không commit credential hoặc Terraform state chứa secret.





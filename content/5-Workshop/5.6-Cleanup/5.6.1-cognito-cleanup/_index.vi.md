---
title: "ECS, ALB và CloudFront"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.6.1. </b> "
---

## Bước 1: Tạo ECS Cluster
Vào: AWS Console → ECS → Clusters → Create cluster
Tạo:    Name: webdemo-cluster
     Infrastructure: AWS Fargate
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/CCluster.jpg)
AWS Console
     │
     ▼
    ECS
     │
     ▼
Create Cluster
     │
     ▼
webdemo-cluster

## Bước 2: Tạo ECS Service
Vào: ECS → Cluster → Create service
Cấu hình:
●Launch type: Fargate
●Container: webdemo
●Desired tasks: 1
●Container port: 8080
ECS Cluster
     │
     ▼
ECS Service
     │
     ▼
Fargate Task
     │
     ▼
Spring Boot :8080

## Bước 3: Tạo Application Load Balancer
Vào: EC2 → Load Balancers → Create Load Balancer → Application Load Balancer
Cấu hình:
●Name: webdemo-alb
●Scheme: Internet-facing
●Listener: HTTP :80
●Target: ECS Service
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/ECSService.jpg)
User
   │
  ▼
ALB :80
  │
  ▼
Target Group
  │
  ▼
ECS Fargate :8080

## Bước 4: Kiểm tra Health Check
Vào: EC2 → Target Groups → webdemo-target-group → Targets
Kiểm tra trạng thái:
ECS Task
   │
   ▼
Health Check
   │
   ├── Healthy ✓
   │
   └── Unhealthy ✗
## Bước 5: Tạo CloudFront Distribution
Vào: AWS Console → CloudFront → Create distribution
Chọn:
●Origin: ALB
●Protocol: HTTP/HTTPS
●Viewer protocol: Redirect HTTP to HTTPS
User
  │
  ▼
CloudFront
  │
  ▼
ALB
  │
  ▼
ECS Fargate
  │
  ▼
Spring Boot

## Bước 6: Kiểm tra CloudFront
Sau khi Distribution chuyển sang: Enabled
Lấy: CloudFront Domain Name
Truy cập domain để kiểm tra website.

Browser
   │
   ▼
CloudFront
   │
   ├── Cache
   │
   ▼
ALB
   │
   ▼
ECS

## Kết quả:
ECS Fargate chạy ứng dụng Spring Boot containerized, ALB phân phối request đến ECS Task và thực hiện health check, trong khi CloudFront cung cấp lớp phân phối nội dung và caching phía trước hệ thống.

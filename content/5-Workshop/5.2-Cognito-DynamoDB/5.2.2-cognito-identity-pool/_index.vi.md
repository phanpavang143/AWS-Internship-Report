---
title: "Subnet, security group và VPC Endpoint"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.2.2. </b> "
---

## Bước 1: Tạo VPC
●Vào AWS Console → VPC → Your VPCs → Create VPC.
●Đặt tên: webdemo-vpc.
●IPv4 CIDR: 10.0.0.0/16.
●Region: Asia Pacific (Singapore) – ap-southeast-1.

## Bước 2: Tạo Public và Private Subnet
Tạo các Subnet trong ít nhất 2 Availability Zone:
![Tạo Subnet](/images/5-Workshop/5.2-Prerequisite/TaoSubnet.jpg)

## Bước 3: Tạo Security Group
Tạo các Security Group riêng cho từng tầng:
●ALB-SG: cho phép HTTP 80 và HTTPS 443 từ Internet.
●ECS-SG: chỉ cho phép port 8080 từ ALB-SG.
●RDS-SG: chỉ cho phép MySQL 3306 từ ECS-SG.
Mô hình luồng:
Internet
   ↓ 80/443
ALB-SG
   ↓ 8080
ECS-SG
   ↓ 3306
RDS-SG

## Bước 4: Tạo VPC Endpoint
Vào AWS Console → VPC → Endpoints → Create endpoint.
●Amazon S3 – truy cập S3 từ Private Subnet.
●ECR API – ECS giao tiếp với Amazon ECR.
●ECR DKR – tải Docker image từ ECR.
●CloudWatch Logs – gửi log từ ECS đến CloudWatch.
![Tạo VPC Entpoint](/images/5-Workshop/5.2-Prerequisite/VPCEntPoint.jpg)

## Bước 5: Kiểm tra kết nối
Kiểm tra:
●ALB nằm trong Public Subnet.
●ECS nằm trong Private Subnet.
●RDS nằm trong Private Subnet.
●Security Group chỉ cho phép các luồng cần thiết.
●ECS có thể truy cập các dịch vụ AWS cần thiết thông qua VPC Endpoint.

## Kết quả:
Kiến trúc mạng được phân tách thành các lớp Public/Private, Security Group kiểm soát lưu lượng giữa từng thành phần và VPC Endpoint giúp ECS trong Private Subnet truy cập các dịch vụ AWS cần thiết mà không phải public trực tiếp tài nguyên ứng dụng.



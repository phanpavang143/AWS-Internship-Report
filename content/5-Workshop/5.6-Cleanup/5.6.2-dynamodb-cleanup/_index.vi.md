---
title: "RDS, Redis và S3"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.6.2. </b> "
---

## Bước 1: Tạo RDS MySQL
Vào: AWS Console → RDS → Databases → Create database
Cấu hình:
●Engine: MySQL
●DB identifier: webdemo-db
●Username: admin
●Password: tự đặt
●VPC: chọn VPC của hệ thống
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/CRMySQL.jpg)

ECS Fargate
     │
     │ JDBC
     ▼
┌──────────────┐
│ RDS MySQL    │
│ webdemo-db   │
└──────────────┘

## Bước 2: Kết nối ECS với RDS
Trong Security Group của RDS, cho phép: Inbound
Type: MySQL
Port: 3306
Source: ECS Security Group
ECS
 │
 │ Port 3306
 ▼
RDS MySQL

## Bước 3: Tạo Redis
Vào: AWS Console → ElastiCache → Redis → Create
Cấu hình:
●Name: webdemo-redis
●Engine: Redis
●VPC: chọn VPC của hệ thống
ECS Fargate
     │
     ├──────────────► RDS MySQL
     │
     └──────────────► Redis
                         │
                         ▼
                    Session / Cache
## Bước 4: Tạo S3 Bucket
Vào: AWS Console → S3 → Create bucket
Tạo: webdemo-product-images
Thiết lập:
●Block Public Access: Enabled
●Versioning: tùy nhu cầu
●Region: ap-southeast-1
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/CRBucket.jpg)
ECS / Spring Boot
       │
       │ Upload Image
       ▼
┌──────────────────┐
│ S3 Bucket        │
│ Product Images   │
└──────────────────┘

## Bước 5: Upload ảnh sản phẩm lên S3
Khi Admin upload sản phẩm:
Admin
  │
  ▼
Spring Boot
  │
  ├── Product information → RDS
  │
  └── Product image ──────► S3
Kiến trúc tổng quát
                   ECS Fargate
                   /       │    \
                  /        │     \
                 ▼      ▼         ▼
          ┌─────────┐ ┌───────┐ ┌──────────────┐
          │RDS MySQL│ │ Redis │ │ S3           │
          │ Database│ │ Cache │ │ Product Image│
          └─────────┘ └───────┘ └──────────────┘

## Kết quả:
RDS MySQL lưu dữ liệu nghiệp vụ, Redis hỗ trợ session/cache dùng chung, còn S3 lưu trữ ảnh sản phẩm. Ba dịch vụ được tích hợp với ECS Fargate để xây dựng hệ thống WebDemo có khả năng mở rộng và tách biệt dữ liệu với ứng dụng.

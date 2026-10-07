---
title: "Amazon RDS MySQL, Amazon S3, CloudFront và ElastiCache Redis"
date: 2026-08-30
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

## Bước 1: Tạo Amazon RDS MySQL
●Vào AWS Console → RDS → Databases → Create database.
●Chọn MySQL.
●Đặt Database name, Username và Password.
●Đặt RDS trong Private Subnet.
●Security Group chỉ cho phép port 3306 từ ECS-SG.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/RDSMySQL.jpg)
ECS Fargate ──3306──> RDS MySQL

## Bước 2: Tạo Amazon S3
●Vào S3 → Create bucket.
●Tạo bucket lưu ảnh sản phẩm: webdemo-product-images.
●Không bật Public Access trực tiếp cho bucket.
●ECS sử dụng IAM Role để upload/download ảnh.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/S3.jpg)
ECS Fargate ──> S3 Product Images

## Bước 3: Cấu hình CloudFront
●Vào CloudFront → Create distribution.
●Chọn S3 bucket làm Origin.
●Sử dụng CloudFront URL để phân phối ảnh.
●Cấu hình HTTPS và Cache Policy phù hợp.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/CloudFront.jpg)
Luồng truy cập:
User → CloudFront → S3

## Bước 4: Tạo ElastiCache Redis
●Vào ElastiCache → Redis → Create.
●Đặt Redis trong Private Subnet.
●Cấu hình Security Group cho Redis.
●Chỉ cho phép ECS-SG truy cập Redis port 6379.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/Redis.jpg)
ECS Fargate ──6379──> ElastiCache Redis

## Bước 5: Tích hợp vào ứng dụng
Ứng dụng Spring Boot kết nối đến:
MySQL  → dữ liệu nghiệp vụ
S3     → ảnh sản phẩm
Redis  → dữ liệu cache
CloudFront → phân phối ảnh
Khi người dùng yêu cầu ảnh sản phẩm, nội dung có thể được phân phối thông qua CloudFront thay vì truy cập trực tiếp S3 mỗi lần.

## Kiến trúc tổng quát
                   Internet
                       │
                       ▼
                  CloudFront
                       │
                       ▼
                      S3
                 Product Images

                       │
                       ▼
                     ALB
                       │
                       ▼
                ECS Fargate
                 /    |     \
                /     |      \
               ▼      ▼       ▼
          RDS MySQL  Redis    SQS
                    ElastiCache

## Kết quả:
RDS đảm nhiệm dữ liệu quan hệ, S3 lưu trữ ảnh, CloudFront tăng hiệu quả phân phối nội dung và Redis giảm tải cho RDS bằng cơ chế caching. Các dịch vụ dữ liệu như RDS và Redis được đặt trong Private Subnet, chỉ cho phép ECS truy cập thông qua Security Group.

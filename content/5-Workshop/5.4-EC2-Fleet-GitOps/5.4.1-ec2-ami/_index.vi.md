---
title: "RDS MySQL và connection pooling"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.4.1. </b> "
---

## Bước 1: Tạo RDS MySQL
●Vào AWS Console → RDS → Databases → Create database.
●Chọn MySQL.
●Cấu hình Database name, Username và Password.
●Chọn Private Subnet.
●Security Group của RDS chỉ cho phép port 3306 từ ECS-SG.
ECS Fargate ──3306──> RDS MySQL
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/Pooling.jpg)

## Bước 2: Cấu hình kết nối Spring Boot
Trong application.properties:
spring.datasource.url=jdbc:mysql://DBHOST:3306/webdemospring.datasource.username={DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

## Bước 3: Cấu hình HikariCP
Spring Boot sử dụng HikariCP làm Connection Pool mặc định.
spring.datasource.hikari.maximum-pool-size=10
spring.datasource.hikari.minimum-idle=2
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000

## Bước 4: Cơ chế Connection Pooling

## HikariCP duy trì một pool các connection:
                Spring Boot
                     │
              ┌──────▼──────┐
              │   HikariCP  │
              │ Connection  │
              │    Pool     │
              └──────┬──────┘
                     │
            ┌────────┼────────┐
            ▼        ▼        ▼
         Conn 1   Conn 2   Conn 3
            └────────┼────────┘
                     ▼
                  RDS MySQL

Connection sau khi sử dụng được trả về Pool để request tiếp theo có thể tái sử dụng.

## Bước 5: Kiểm tra và tối ưu
Theo dõi:
●Số lượng connection trên RDS.
●CPU và Memory của RDS.
●Thời gian phản hồi ứng dụng.
●Số lượng ECS Task chạy đồng thời.
●HikariCP active/idle connections.
Đặc biệt, khi sử dụng nhiều ECS Task, cần tính tổng connection pool của tất cả Task để tránh vượt quá giới hạn connection của RDS.

## Kết quả:
RDS MySQL đảm nhiệm lưu trữ dữ liệu tập trung, trong khi HikariCP quản lý và tái sử dụng các database connection. Cách triển khai này giúp giảm overhead khi tạo connection và phù hợp với mô hình Spring Boot + ECS Fargate + RDS MySQL.

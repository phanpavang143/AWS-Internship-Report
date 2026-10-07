---
title: "Bảo mật dữ liệu và backup"
date: 2026-08-30
weight: 4
chapter: false
pre: " <b> 5.4.4. </b> "
---

## Bước 1: Bảo mật RDS MySQL
●Đặt RDS trong Private Subnet.
●Không cho phép truy cập trực tiếp từ Internet.
●Security Group chỉ cho phép ECS-SG → RDS port 3306.
●Bật mã hóa dữ liệu khi tạo RDS nếu phù hợp với yêu cầu hệ thống.
Internet
   X
   │
Private Subnet
   │
ECS ──3306──> RDS MySQL

## Bước 2: Backup RDS
Vào: AWS Console → RDS → Databases → chọn Database → Modify
Cấu hình Automated Backups và thời gian lưu trữ backup phù hợp.
RDS hỗ trợ Point-in-Time Recovery, cho phép khôi phục database về một thời điểm trong khoảng thời gian backup còn được lưu.

## Bước 3: Bảo vệ dữ liệu trên S3
●Bật Block Public Access.
●Sử dụng IAM Role để ECS truy cập S3.
●Bật Versioning để giữ các phiên bản của object.
●Có thể sử dụng Lifecycle Policy để quản lý dữ liệu cũ.
ECS → IAM Role → S3
                  │
               Versioning

## Bước 4: Bảo vệ Secrets
Sử dụng AWS Secrets Manager để lưu:
●RDS username/password.
●Redis credentials nếu có.
●Các thông tin cấu hình nhạy cảm khác.
ECS Task sử dụng IAM Role để đọc Secret thay vì lưu password trong source code.

## Bước 5: Kiểm soát quyền truy cập
Áp dụng nguyên tắc Least Privilege:
ALB → ECS
ECS → RDS
ECS → S3
ECS → Redis
Mỗi thành phần chỉ được cấp quyền cần thiết cho chức năng của mình.

## ước 6: Kiểm tra khả năng khôi phục
Thực hiện kiểm tra định kỳ:
●Khôi phục RDS từ Snapshot.
●Kiểm tra Point-in-Time Recovery.
●Khôi phục phiên bản object trên S3.
●Kiểm tra khả năng truy cập Secrets sau khi triển khai lại ECS.

## Kết quả:
Dữ liệu được bảo vệ bằng nhiều lớp từ Network → IAM → Encryption → Secrets, trong khi RDS Backup, Snapshot và S3 Versioning giúp tăng khả năng khôi phục dữ liệu khi xảy ra sự cố.



---
title: "S3 và CloudFront cho ảnh"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.4.2. </b> "
---

## Bước 1: Tạo S3 Bucket
●Vào AWS Console → S3 → Create bucket.
●Đặt tên: webdemo-product-images.
●Chọn Region: ap-southeast-1.
●Bật Block all public access để không public trực tiếp bucket.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/S3Bucket.jpg)

## Bước 2: Cấp quyền cho ứng dụng
ECS sử dụng IAM Role để upload và đọc ảnh từ S3.
ECS Fargate ── IAM Role ──> S3

## Bước 3: Upload ảnh sản phẩm
Ứng dụng Spring Boot nhận ảnh từ Admin và upload lên S3:
Admin
  ↓
Spring Boot / ECS
  ↓
Amazon S3
  ↓
Product Image

## Bước 4: Tạo CloudFront Distribution
Vào: AWS Console → CloudFront → Create distribution
●Chọn S3 bucket làm Origin.
●Sử dụng HTTPS.
●Cấu hình Cache Policy phù hợp với nội dung ảnh.
●Sử dụng CloudFront URL để phân phối ảnh.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/Distribution.jpg)
## Luồng truy cập:
User
  ↓
CloudFront
  ↓
S3

Bước 5: Cấu hình bảo mật
S3 không cần mở Public Access. CloudFront được cấu hình để truy cập Origin S3 thông qua cơ chế kiểm soát truy cập phù hợp.
Internet
   │
   ▼
CloudFront
   │
   ▼
Private S3 Bucket

## Bước 6: Kiểm tra và tối ưu
●Upload một ảnh sản phẩm lên S3.
●Truy cập ảnh thông qua CloudFront.
●Kiểm tra CloudFront phân phối nội dung thành công.
●Theo dõi cache và số lượng request.
●Khi cập nhật ảnh có cùng tên, thực hiện invalidation hoặc sử dụng tên object/version mới để tránh cache cũ.

## Kết quả:
S3 đảm nhiệm lưu trữ ảnh bền vững, còn CloudFront đảm nhiệm phân phối ảnh đến người dùng thông qua CDN. Ứng dụng ECS không phải trực tiếp phục vụ toàn bộ file ảnh, giúp giảm tải cho Spring Boot và cải thiện khả năng mở rộng của hệ thống.




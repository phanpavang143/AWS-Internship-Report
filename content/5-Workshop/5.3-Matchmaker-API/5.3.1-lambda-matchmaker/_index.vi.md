---
title: "Build image và ECS service"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.3.1. </b> "
---

## Bước 1: Build ứng dụng
Tại thư mục source: mvn clean package
Kiểm tra file .jar được tạo trong thư mục target/.

## Bước 2: Build Docker Image
docker build -t webdemo:latest .
Kiểm tra image:docker images.

## Bước 3: Đẩy Image lên Amazon ECR
●Vào AWS Console → ECR → Repositories → Create repository.
●Tạo repository: webdemo.
●Đăng nhập Docker vào ECR.
●Tag image và push:
![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/AmazonECR.jpg)

docker tag webdemo:latest <ECR_URI>:latest
docker push <ECR_URI>:latest
Sau đó kiểm tra image trong ECR → webdemo → Images.

## Bước 4: Tạo Secret
Vào: AWS Console → Secrets Manager → Store a new secret
![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/Secret.jpg)

## Bước 5: Cấp quyền cho ECS
Tại ECS Task Definition, cấu hình container sử dụng Secret từ Secrets Manager.
Task Execution/Task Role cần được cấp quyền phù hợp để ECS có thể truy cập Secret.

## Bước 6: Kiểm tra triển khai
Kiểm tra:
●Docker Image đã có trên ECR.
●ECS Task lấy đúng image từ ECR.
●Secret được ECS đọc thành công.
●Database connection hoạt động.
●Không xuất hiện password trong source code hoặc Git repository.

## Kết quả:
Docker giúp chuẩn hóa môi trường chạy ứng dụng, Amazon ECR lưu trữ image và AWS Secrets Manager bảo vệ thông tin nhạy cảm. ECS Fargate có thể sử dụng image và secrets này để triển khai ứng dụng an toàn.


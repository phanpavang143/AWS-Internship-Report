---
title: "Chuẩn bị môi trường, AWS Region và công cụ triển khai"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---


## 1. Chuẩn bị AWS Account
Đăng nhập AWS Management Console và đảm bảo tài khoản có quyền sử dụng các dịch vụ cần thiết.

## 2. Chọn AWS Region
Ở góc phải AWS Console, chọn:Asia Pacific (Singapore) , ap-southeast-1
![Chọn Region ](/images/5-Workshop/5.1-Workshop-overview/ChonRegion.jpg)

## 3. Chuẩn bị Java và Maven
Cài Java 25 và Maven để build ứng dụng Spring Boot. Kiểm tra: java -version, mvn -version
## 4. Chuẩn bị Git và Source Code
Cài Git, clone project WebDemo và kiểm tra source code: git clone <repository>, cd WebDemo

## 5. Cài đặt Docker
Cài Docker Desktop và kiểm tra: docker --version
Build thử Docker Image: docker build -t webdemo:latest .

## 6. Cấu hình AWS CLI
Cài AWS CLI và cấu hình: aws configure
Chọn Region: ap-southeast-1
Kiểm tra kết nối: aws sts get-caller-identity

## 7. Cài đặt Terraform
Cài Terraform và kiểm tra: terraform version
Khởi tạo: terraform init
## 8. Kiểm tra toàn bộ môi trường
Đảm bảo WebDemo chạy được trên local, Docker hoạt động, AWS CLI kết nối thành công và Terraform khởi tạo thành công trước khi bắt đầu tạo hạ tầng AWS.
![Engineer ](/images/5-Workshop/5.1-Workshop-overview/Engineer.jpg)



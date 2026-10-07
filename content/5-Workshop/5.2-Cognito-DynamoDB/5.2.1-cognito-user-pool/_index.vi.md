---
title: "Terraform backend và biến môi trường"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.2.1. </b> "
---

## Bước 1: Tạo S3 Bucket lưu Terraform State
●Vào AWS Console → S3 → Create bucket.
●Đặt tên bucket: webdemo-terraform-state.
●Chọn Region: Asia Pacific (Singapore) – ap-southeast-1.
●Bật Block all public access.
●Bật Bucket Versioning để có thể khôi phục các phiên bản State trước đó.
![Minh họa AWS](/images/5-Workshop/5.2-Prerequisite/S3.jpg)

## Bước 2: Cấu hình Terraform Backend
Trong backend.tf:
terraform {
  backend "s3" {
    bucket = "webdemo-terraform-state"
    key    = "webdemo/terraform.tfstate"
    region = "ap-southeast-1" }
}

Khởi tạo Backend: terraform init

## Bước 3: Khai báo biến môi trường
Trong variables.tf:
variable "db_username" {
  type      = string
  sensitive = true }
variable "db_password" {
  type      = string
 sensitive = true }

Trên Windows PowerShell:
$env:TF_VAR_db_username="admin"
$env:TF_VAR_db_password="your-password"

## Bước 4: Không lưu thông tin nhạy cảm vào GitHub
Thêm vào .gitignore:
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
.env

## Bước 5: Kiểm tra và triển khai
terraform init
terraform validate
terraform plan
terraform apply

## Kiểm tra State: terraform state list
Sau khi triển khai, kiểm tra S3 để xác nhận file terraform.tfstate đã được lưu trữ.

## Kết quả:
Terraform State được quản lý tập trung trên Amazon S3, trong khi các thông tin cấu hình và dữ liệu nhạy cảm được truyền qua Environment Variables/Secrets, giúp tăng tính an toàn và thuận tiện khi triển khai nhiều môi trường.




---
title: "State, output và secrets"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.2.3. </b> "
---

## 1. Quản lý Terraform State
Tạo file: terraform.tfstate
File này lưu trạng thái hạ tầng Terraform. Không đưa file State lên GitHub vì có thể chứa thông tin nhạy cảm.

## 2. Khai báo Output
Tạo outputs.tf để hiển thị thông tin cần thiết:
output "vpc_id" {
  value = aws_vpc.main.id }
output "rds_endpoint" {
  value = aws_db_instance.mysql.address }
Sau khi triển khai: terraform output
Terraform sẽ hiển thị các giá trị Output để sử dụng cho các bước tiếp theo.

## 3. Quản lý Secrets
●Database username/password.
●Secret key.
●Các thông tin cấu hình nhạy cảm khác.
Trên AWS Console: AWS Secrets Manager → Store a new secret → chọn loại thông tin → nhập giá trị → lưu Secret.

## 4. Bảo vệ file nhạy cảm
Thêm vào .gitignore: .terraform/
*.tfstate
*.tfstate.*
*.tfvars .env

## 5. Kiểm tra
Sau khi cấu hình: terraform plan, terraform apply, terraform output
![Minh họa AWS](/images/5-Workshop/5.2-Prerequisite/Kiemtra1.jpg)
![Minh họa AWS](/images/5-Workshop/5.2-Prerequisite/Kiemtra2.jpg)
![Minh họa AWS](/images/5-Workshop/5.2-Prerequisite/Kiemtra3.jpg)

## Kết quả: Terraform State được quản lý an toàn, Output cung cấp thông tin cần thiết cho các bước triển khai tiếp theo, còn Secrets được lưu riêng và không xuất hiện trực tiếp trong source code.




---
title: "Terraform, VPC, private subnet và bảo mật mạng"
date: 2026-09-25
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

1. Khởi tạo Terraform
Tạo thư mục Terraform và cấu hình AWS Region:
provider "aws" {
  region = "ap-southeast-1" }
Chạy: terraform init

2. Tạo VPC
Vào AWS Console → VPC → Your VPCs → Create VPC.
●Name: webdemo-vpc
●IPv4 CIDR: 10.0.0.0/16
![Tạo VPC](/images/5-Workshop/5.2-Prerequisite/VPC.jpg)

3. Tạo Subnet
Vào VPC → Subnets → Create subnet.
Tạo:
●2 Public Subnet → dùng cho ALB.
●2 Private Subnet → dùng cho ECS và RDS.
●Đặt trên 2 Availability Zone.

4. Tạo Internet Gateway
Vào VPC → Internet Gateways → Create, sau đó Attach vào webdemo-vpc.
Internet Gateway chỉ phục vụ Public Subnet.
![Internet Gateway](/images/5-Workshop/5.2-Prerequisite/InternetGateway.jpg)

5. Cấu hình Route Table
Tạo Public Route Table và thêm: 0.0.0.0/0 → Internet Gateway
Gắn Route Table với 2 Public Subnet. Private Subnet không route trực tiếp qua Internet Gateway.

6. Tạo Security Groups
Thiết lập luồng: Internet → ALB → ECS → RDS
           80/443  8080  3306
●ALB: cho phép 80/443 từ Internet.
●ECS: chỉ cho phép 8080 từ ALB.
●RDS: chỉ cho phép 3306 từ ECS.
●Không mở RDS 3306 cho 0.0.0.0/0.

7. Triển khai bằng Terraform
Kiểm tra và triển khai: terraform validate, terraform plan, terraform apply

8. Kiểm tra bảo mật
Trên VPC Console, kiểm tra:
●ECS và RDS nằm trong Private Subnet.
●ALB nằm trong Public Subnet.
●RDS không truy cập trực tiếp từ Internet.
Security Group chỉ mở các port cần thiết.
![Kiểm tra bảo mật](/images/5-Workshop/5.2-Prerequisite/Kiemtrabaomat.jpg)

Kết quả: Xây dựng được mạng AWS theo mô hình Internet → ALB → ECS → RDS, trong đó ECS và RDS được bảo vệ trong Private Subnet và quản lý hạ tầng bằng Terraform.
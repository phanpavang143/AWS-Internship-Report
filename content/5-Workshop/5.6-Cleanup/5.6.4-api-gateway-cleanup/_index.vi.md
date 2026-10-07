---
title: "VPC Endpoint và NAT Gateway"
date: 2026-08-30
weight: 4
chapter: false
pre: " <b> 5.6.4. </b> "
---

## Bước 1: Tạo NAT Gateway
Vào: AWS Console → VPC → NAT Gateways → Create NAT Gateway
●Chọn Public Subnet.
●Connectivity type: Public.
●Gán Elastic IP.
Private Subnet
      │
      ▼
 NAT Gateway
      │
      ▼
 Internet Gateway
      │
      ▼
  Internet

## Bước 2: Cấu hình Route Table cho Private Subnet
Vào: VPC → Route Tables → Private Route Table → Routes
Thêm:
0.0.0.0/0
    │
    ▼
NAT Gateway
Bước 3: Tạo VPC Endpoint cho S3
Vào: VPC → Endpoints → Create endpoint
●Service category: AWS services
●Service: S3
●Type: Gateway
●Chọn VPC webdemo-vpc.
●Chọn Route Table của Private Subnet.
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/EntpointST.jpg)

ECS Fargate
     │
     ▼
Private Subnet
     │
     ▼
VPC Endpoint
     │
     ▼
     S3

## Bước 4: Kiểm tra kết nối
Kiểm tra ECS có thể:
●Truy cập Internet thông qua NAT Gateway.
●Truy cập S3 thông qua VPC Endpoint.
●Không cần Public IP cho ECS Task.
                ┌──► NAT Gateway ──► Internet
ECS Fargate ─────┤
                 └──► VPC Endpoint ──► S3

## Kết quả
NAT Gateway cung cấp đường ra Internet cho các tài nguyên trong Private Subnet, trong khi VPC Endpoint cho phép ECS truy cập S3 thông qua mạng AWS mà không cần đi qua Internet. Cách triển khai này giúp WebDemo giữ ECS trong Private Subnet và tăng tính an toàn cho kiến trúc.

---
title: "Terraform destroy an toàn và kiểm tra chi phí"
date: 2026-08-30
weight: 5
chapter: false
pre: " <b> 5.6.5. </b> "
---

## Bước 1: Kiểm tra tài nguyên trước khi Destroy
Chạy: terraform plan
Kiểm tra các tài nguyên sẽ bị xóa:

Terraform
   │
   ▼
terraform plan
   │
   ▼
Danh sách tài nguyên:
   │
   ├── ECS
   ├── RDS
   ├── S3
   ├── Redis
   ├── ALB
   └── NAT Gateway

## Bước 2: Backup dữ liệu quan trọng
Trước khi destroy:
●RDS: tạo DB Snapshot.
●S3: backup/download các file cần giữ.
●Kiểm tra Terraform State.

RDS ─────► Snapshot
S3  ─────► Backup
              │
              ▼
        Terraform Destroy

## Bước 3: Destroy hạ tầng
Sau khi xác nhận: terraform destroy
Terraform sẽ hiển thị danh sách tài nguyên và yêu cầu xác nhận:
Plan: 0 to add,
      0 to change,
      X to destroy.
Do you really want to destroy all resources?
Enter a value: yes

## Bước 4: Kiểm tra tài nguyên còn sót
Vào AWS Console kiểm tra:
ECS
RDS
ElastiCache
S3
ALB
NAT Gateway
Elastic IP
CloudFront
SQS
Lambda
CloudWatch

## Bước 5: Kiểm tra chi phí AWS
Vào: AWS Console → Billing and Cost Management → Cost Explorer
Chọn:
●Time range: Last 7 days / Last 30 days.
●Group by: Service.

AWS Billing
     │
     ▼
Cost Explorer
     │
     ▼
Chi phí theo Service
     │
     ├── ECS
     ├── RDS
     ├── NAT Gateway
     ├── S3
     └── CloudFront

## Kiến trúc tổng quát:
Terraform
    │
    ▼
terraform plan
    │
    ▼
Backup dữ liệu
    │
    ▼
terraform destroy
    │
    ▼
AWS Resources ──► Kiểm tra còn sót
    │
    ▼
Cost Explorer
    │
    ▼
Kiểm soát chi phí

## Kết quả:
Terraform được sử dụng để kiểm tra → backup → destroy → xác nhận tài nguyên còn sót → kiểm tra chi phí, giúp tránh xóa nhầm dữ liệu quan trọng và hạn chế phát sinh chi phí AWS ngoài dự kiến.

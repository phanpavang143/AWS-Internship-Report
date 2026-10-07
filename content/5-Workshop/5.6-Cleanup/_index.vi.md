---
title: "Cleanup hạ tầng AWS và kiểm soát chi phí"
date: 2026-08-30
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

## Bước 1: Kiểm tra các tài nguyên đang sử dụng
Vào: AWS Console → Resource Explorer / các dịch vụ AWS
Kiểm tra các tài nguyên:
●ECS / Fargate
●RDS MySQL
●S3
●CloudFront
●ElastiCache Redis
●SQS
●Lambda
●ALB
●CloudWatch
●NAT Gateway

## Bước 2: Xóa ECS và Load Balancer
Vào: ECS → Clusters → chọn cluster → Delete
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/ESCCulers.jpg)
Sau đó kiểm tra:
EC2 → Load Balancers
Xóa ALB không còn sử dụng.
ECS Service
    │
    ▼
Fargate Tasks
    │
    ▼
ALB
    │
    ▼
Delete Resources

## Bước 3: Xóa RDS và ElastiCache
Vào: RDS → Databases → chọn database → Actions → Delete
Sau đó: ElastiCache → Redis caches → Delete
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/DLec.jpg)

## Bước 4: Kiểm tra S3 và CloudFront
Vào: S3 → Buckets
Xóa các bucket không còn sử dụng.
Sau đó:
CloudFront → Distributions
Disable và xóa distribution không cần thiết.

## Bước 5: Kiểm tra NAT Gateway và Elastic IP
Vào: VPC → NAT Gateways
Xóa NAT Gateway không sử dụng.
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/DLNat.jpg)

## Bước 6: Kiểm tra chi phí
Vào: AWS Console → Billing and Cost Management → Cost Explorer
Kiểm tra chi phí theo:
●Service.
●Region.
●Ngày/tháng.
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/Cost.jpg)

## Bước 7: Tạo cảnh báo chi phí
Vào: Billing → Budgets → Create budget
AWS Cost
    │
    ▼
Budget $10
    │
    ├── 80% → Warning
    │
    └── 100% → Alert

## Bước 8: Kiểm tra lần cuối
Đảm bảo các tài nguyên thử nghiệm đã được xử lý:
ECS       ✓
ALB       ✓
RDS       ✓
Redis     ✓
S3        ✓
CloudFront ✓
NAT GW    ✓
Elastic IP ✓
Lambda    ✓
SQS       ✓
Kiến trúc Cleanup
             AWS Account
                   │
          ┌────────┴────────┐
          ▼                                          ▼
   AWS Resources                       Billing
          │                                            │
          ▼                                          ▼
   Cleanup/Delete                     Cost Explorer
          │                                              │
          ▼                                            ▼
 No unused resources             Budget Alert

## Kết quả:
Cleanup giúp loại bỏ các tài nguyên AWS không còn sử dụng, đặc biệt là RDS, NAT Gateway, ALB, ElastiCache và Elastic IP. Kết hợp Cost Explorer + AWS Budgets giúp theo dõi và kiểm soát chi phí, hạn chế phát sinh chi phí ngoài dự kiến.
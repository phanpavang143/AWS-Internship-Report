---
title: "SQS và hàng đợi order"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.5.1. </b> "
---

## Bước 1: Tạo Order Queue
Vào: AWS Console → SQS → Create queue
Tạo queue:
Name: webdemo-order-queue
Type: Standard
![Minh họa AWS](/images/5-Workshop/5.5-Policy/OrderQueue.jpg)

## Bước 2: Gửi Order Event từ ECS
Khi người dùng hoàn tất đặt hàng:
User
 ↓
ALB
 ↓
ECS / Spring Boot
 ↓
Create Order
 ↓
SQS Order Queue

## Bước 3: Lambda xử lý Order
Cấu hình Lambda → Add trigger → SQS.
Khi có message:
SQS Order Queue
       ↓
     Lambda
       ↓
Process Order Event

## Bước 4: Xử lý lỗi với Dead-Letter Queue
Tạo thêm: webdemo-order-dlq
Order Queue
     │
     ├── Success → Processed
     │
     └── Failed repeatedly
                  ↓
                 DLQ

## Bước 5: Theo dõi Order Queue
Sử dụng CloudWatch để theo dõi:
●Số lượng message đang chờ.
●Số message được xử lý.
●Số message lỗi.
●Lambda invocation và error.
●Độ trễ xử lý queue.
Kiến trúc tổng quát:
                 User
                   │
                   ▼
                  ALB
                   │
                   ▼
             ECS Fargate
                   │
              Create Order
                   │
                   ▼
            ┌──────────────┐
            │ SQS Order    │
            │    Queue     │
            └──────┬───────┘
                   │
                   ▼
                Lambda
                   │
                   ▼
             Order Processing
                   │
                   ▼
              CloudWatch

        Failed Messages
              │
              ▼
             DLQ

## Kết quả:
SQS giúp xây dựng cơ chế xử lý Order bất đồng bộ, giảm sự phụ thuộc trực tiếp giữa quá trình đặt hàng và các tác vụ nền. Kết hợp Lambda + DLQ + CloudWatch giúp hệ thống xử lý lỗi và theo dõi trạng thái hàng đợi hiệu quả hơn.

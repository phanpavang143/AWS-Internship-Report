---
title: "SQS và Lambda"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.6.3. </b> "
---

## Bước 1: Tạo SQS Queue
Vào: AWS Console → SQS → Create queue
Tạo queue:
●Name: webdemo-order-queue
●Type: Standard
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/SQSQue.jpg)

ECS / Spring Boot
       │
       │ Order Event
       ▼
┌──────────────────┐
│ SQS Order Queue  │
└──────────────────┘

## Bước 2: Gửi Order Event từ ECS
Khi người dùng hoàn tất đặt hàng:
User
  │
  ▼
ALB
  │
  ▼
ECS / Spring Boot
  │
  ▼
Create Order
  │
  ▼
SQS Order Queue
SQS lưu message để xử lý bất đồng bộ.

## Bước 3: Tạo Lambda Function
Vào: AWS Console → Lambda → Create function
Tạo:
●Name: webdemo-order-processor
●Runtime: Python
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/LBFuntion.jpg)

SQS Order Queue
       │
       │ Message
       ▼
     Lambda
       │
       ▼
Process Order Event

## Bước 4: Kết nối SQS với Lambda
Vào: Lambda → webdemo-order-processor → Add trigger → SQS
Chọn: webdemo-order-queue
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/ADDtrigger.jpg)

Sau khi có message, Lambda sẽ được kích hoạt để xử lý.
SQS
 │
 │ Message
 ▼
Lambda
 │
 ▼
Order Processing

## Bước 5: Xử lý lỗi bằng DLQ
Tạo thêm queue: webdemo-order-dlq
Cấu hình Redrive policy cho Order Queue.
SQS Order Queue
       │
       ├── Success ──► Lambda ──► Processed
       │
       └── Failed repeatedly
                    │
                    ▼
                   DLQ

## Kết quả:
SQS giúp tách quá trình đặt hàng khỏi các tác vụ xử lý nền, cho phép xử lý bất đồng bộ. Lambda tự động xử lý message từ queue, còn DLQ lưu các message xử lý thất bại để kiểm tra và xử lý lại.
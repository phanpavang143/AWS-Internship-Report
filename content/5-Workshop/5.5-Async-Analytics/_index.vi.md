---
title: "Amazon SQS, AWS Lambda, CloudWatch và CloudTrail"
date: 2026-08-30
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---

## Bước 1: Tạo Amazon SQS
●Vào AWS Console → SQS → Create queue.
●Chọn Standard Queue.
●Đặt tên: webdemo-events.
●Cấu hình Visibility Timeout và Message Retention phù hợp.
![Minh họa AWS](/images/5-Workshop/5.5-Policy/SQS.jpg)
Ứng dụng ECS gửi các event vào Queue:
ECS Fargate
     │
     ▼
Amazon SQS
     │
     ▼
Event Processing

## Bước 2: Tạo AWS Lambda
●Vào AWS Console → Lambda → Create function.
●Chọn Author from scratch.
●Chọn runtime phù hợp với ứng dụng xử lý.
●Cấp IAM Role với quyền cần thiết.
![Minh họa AWS](/images/5-Workshop/5.5-Policy/Lambda.jpg)
Lambda có thể được kích hoạt khi có message mới trong SQS:
ECS → SQS → Lambda
              │
              ▼
         Process Event
Sau khi xử lý thành công, message được Lambda xử lý và loại khỏi Queue theo cơ chế của event source mapping.

## Bước 3: Cấu hình CloudWatch
Vào: AWS Console → CloudWatch
Theo dõi:
●ECS CPU/Memory.
●ALB Request Count và Response.
●RDS CPU/Database Connections.
●SQS số lượng message.
●Lambda Invocations và Errors.
●Application Logs.
![Minh họa AWS](/images/5-Workshop/5.5-Policy/CloudWatch.jpg)
Tạo CloudWatch Alarm để cảnh báo khi metric vượt ngưỡng.
ECS ─┐
ALB ─┤
RDS ─┤──> CloudWatch ──> Alarm
SQS ─┤
Lambda ┘

## Bước 4: Cấu hình CloudTrail
Vào: AWS Console → CloudTrail → Trails → Create trail
CloudTrail ghi nhận các hoạt động API trên tài khoản AWS, hỗ trợ:
●Theo dõi thao tác quản trị.
●Kiểm tra lịch sử API call.
●Hỗ trợ kiểm tra và truy vết sự kiện bảo mật.
User / IAM
    │
    ▼
AWS API
    │
    ▼
CloudTrail
    │
    ▼
Event History / S3

## Bước 5: Phân quyền IAM
Tạo IAM Role riêng cho từng thành phần:
ECS Task Role
   ├── SQS SendMessage
   └── S3 Access

Lambda Execution Role
   ├── SQS ReceiveMessage
   └── CloudWatch Logs

Chỉ cấp các quyền cần thiết theo nguyên tắc Least Privilege.

## Bước 6: Kiểm tra hệ thống
Thực hiện một event từ ứng dụng:
ECS
 ↓
SQS
 ↓
Lambda
 ↓
CloudWatch Logs

Sau đó kiểm tra:
●Message xuất hiện trong SQS.
●Lambda được invoke.
●Lambda xử lý thành công.
●Log xuất hiện trong CloudWatch.
●Hoạt động AWS được ghi nhận trong CloudTrail.

## Kết quả:
SQS và Lambda tạo cơ chế event-driven/asynchronous processing, giúp tách các tác vụ nền khỏi luồng request chính. CloudWatch đảm nhiệm monitoring và logging, trong khi CloudTrail cung cấp audit trail cho các hoạt động trên AWS, hoàn thiện khả năng vận hành và giám sát hệ thống.
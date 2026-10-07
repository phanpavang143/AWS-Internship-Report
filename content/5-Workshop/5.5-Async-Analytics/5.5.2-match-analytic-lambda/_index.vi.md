---
title: "Lambda, CloudWatch và CloudTrail"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.5.2. </b> "
---

## Bước 1: Tạo Lambda Function
Vào: AWS Console → Lambda → Create function
Tạo function:
●Name: webdemo-order-processor
●Runtime: Python
![Minh họa AWS](/images/5-Workshop/5.5-Policy/Funtion.jpg)
AWS Console
     │
     ▼
   Lambda
     │
     ▼
Create function
     │
     ▼
webdemo-order-processor

## Bước 2: Kết nối Lambda với SQS
Vào: Lambda → webdemo-order-processor → Add trigger → SQS
Chọn: webdemo-order-queue
SQS Order Queue
       │
       │ Message
       ▼
    Lambda
       │
       ▼
Process Order Event
![Minh họa AWS](/images/5-Workshop/5.5-Policy/OrderEvent.jpg)

## Bước 3: Kiểm tra Log bằng CloudWatch
Sau khi Lambda được gọi:
Vào: AWS Console → CloudWatch → Logs → Log groups
Chọn: /aws/lambda/webdemo-order-processor
Lambda
   │
   │ Execution Log
   ▼
CloudWatch Logs
   │
   ▼
Log Stream
   │
   ▼
Order Processing Log
Theo dõi:
●Lambda execution.
●Order processing.
●Error.
●Execution time.
![Minh họa AWS](/images/5-Workshop/5.5-Policy/CloudWatchLog.jpg)

## Bước 4: Theo dõi Lambda bằng CloudWatch Metrics
Vào: CloudWatch → Metrics → AWS/Lambda
Chọn function: webdemo-order-processor
Lambda
   │
   ├── Invocations
   ├── Errors
   ├── Duration
   └── Throttles
          │
          ▼
     CloudWatch
![Minh họa AWS](/images/5-Workshop/5.5-Policy/CLWMetrics.jpg)


## Bước 5: Kiểm tra hoạt động bằng CloudTrail
Vào: AWS Console → CloudTrail → Event history
Tìm các hoạt động liên quan đến Lambda:
●CreateFunction
●UpdateFunctionCode
●UpdateFunctionConfiguration
AWS User / Service
        │
        │ API Call
        ▼
    AWS Lambda
        │
        ▼
    CloudTrail
        │
        ▼
  Event History

## Bước 6: Kiến trúc tổng quát
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
            ┌───────────────┐
            │ SQS Order     │
            │ Queue         │
            └───────┬───────┘
                    │
                    ▼
                 Lambda
                    │
                    ▼
            Order Processing
                    │
                    ▼
              CloudWatch
              ┌─────┴─────┐
              ▼           ▼
             Logs       Metrics

 ## Kết quả:
Lambda xử lý Order event từ SQS theo cơ chế bất đồng bộ. CloudWatch giúp theo dõi log, metrics và lỗi của Lambda, trong khi CloudTrail ghi nhận các hoạt động/API call để phục vụ kiểm tra và audit hệ thống.


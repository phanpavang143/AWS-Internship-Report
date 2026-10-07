---
title: "Lambda, CloudWatch and CloudTrail"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.5.2. </b> "
---

## Step 1: Create a Lambda Function
Go to: AWS Console → Lambda → Create function
Create the function:
● Name: webdemo-order-processor
● Runtime: Python
![AWS Illustration](/images/5-Workshop/5.5-Policy/Funtion.jpg)
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

## Step 2: Connect Lambda to SQS
Go to: Lambda → webdemo-order-processor → Add trigger → SQS
Select: webdemo-order-queue
SQS Order Queue
       │
       │ Message
       ▼
    Lambda
       │
       ▼
Process Order Event
![AWS Illustration](/images/5-Workshop/5.5-Policy/OrderEvent.jpg)

## Step 3: Check Logs using CloudWatch
After the Lambda function is invoked:
Go to: AWS Console → CloudWatch → Logs → Log groups
Select: /aws/lambda/webdemo-order-processor
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
Monitor:
● Lambda execution.
● Order processing.
● Errors.
● Execution time.
![AWS Illustration](/images/5-Workshop/5.5-Policy/CloudWatchLog.jpg)

## Step 4: Monitor Lambda with CloudWatch Metrics
Go to: CloudWatch → Metrics → AWS/Lambda
Select function: webdemo-order-processor
Lambda
   │
   ├── Invocations
   ├── Errors
   ├── Duration
   └── Throttles
          │
          ▼
     CloudWatch
![AWS Illustration](/images/5-Workshop/5.5-Policy/CLWMetrics.jpg)

## Step 5: Verify activity using CloudTrail
Go to: AWS Console → CloudTrail → Event history
Look for Lambda-related activities:
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

## Step 6: High-level architecture
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

 ## Outcome:
Lambda processes Order events from SQS asynchronously. CloudWatch enables monitoring of Lambda logs, metrics, and errors, while CloudTrail records activities and API calls for system inspection and auditing.

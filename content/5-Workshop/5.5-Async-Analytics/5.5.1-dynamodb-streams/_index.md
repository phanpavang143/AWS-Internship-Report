---
title: "SQS and the order queue"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.5.1. </b> "
---
## Step 1: Create the Order Queue
Go to: AWS Console → SQS → Create queue
Create queue:
Name: webdemo-order-queue
Type: Standard
![AWS Illustration](/images/5-Workshop/5.5-Policy/OrderQueue.jpg)

## Step 2: Send Order Event from ECS
When the user completes an order:
User
 ↓
ALB
 ↓
ECS / Spring Boot
 ↓
Create Order
 ↓
SQS Order Queue

## Step 3: Lambda processes the Order
Configure Lambda → Add trigger → SQS.
Upon receiving a message:
SQS Order Queue
       ↓
     Lambda
       ↓
Process Order Event

## Step 4: Error handling with Dead-Letter Queue
Create: webdemo-order-dlq
Order Queue
     │
     ├── Success → Processed
     │
     └── Failed repeatedly
                  ↓
                 DLQ

## Step 5: Monitoring the Order Queue
Use CloudWatch to monitor:
● Number of pending messages.
● Number of processed messages.
● Number of failed messages.
● Lambda invocations and errors.
● Queue processing latency.
Overall architecture:
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

## Results:
SQS enables an asynchronous order processing mechanism, reducing direct dependency between the ordering process and background tasks. The combination of Lambda, DLQ, and CloudWatch allows for more effective error handling and queue status monitoring.

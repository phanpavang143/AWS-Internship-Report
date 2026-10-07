---
title: "SQS and Lambda"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.6.3. </b> "
---

## Step 1: Create an SQS Queue
Go to: AWS Console → SQS → Create queue
Create the queue:
● Name: webdemo-order-queue
● Type: Standard
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/SQSQue.jpg)

ECS / Spring Boot
       │
       │ Order Event
       ▼
┌──────────────────┐
│ SQS Order Queue  │
└──────────────────┘

## Step 2: Send Order Event from ECS
When a user completes an order:
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
SQS stores the message for asynchronous processing.

## Step 3: Create Lambda Function
Go to: AWS Console → Lambda → Create function
Configure:
● Name: webdemo-order-processor
● Runtime: Python
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/LBFuntion.jpg)

SQS Order Queue
       │
       │ Message
       ▼
     Lambda
       │
       ▼
Process Order Event

## Step 4: Connect SQS to Lambda
Go to: Lambda → webdemo-order-processor → Add trigger → SQS
Select: webdemo-order-queue
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/ADDtrigger.jpg)

Once a message arrives, Lambda will be triggered to process it.
SQS
 │
 │ Message
 ▼
Lambda
 │
 ▼
Order Processing

## Step 5: Error handling with DLQ
Create an additional queue: `webdemo-order-dlq`
Configure the Redrive policy for the Order Queue.
SQS Order Queue
       │
       ├── Success ──► Lambda ──► Processed
       │
       └── Failed repeatedly
                    │
                    ▼
                   DLQ

## Result:
SQS decouples the ordering process from background processing tasks, enabling asynchronous processing. Lambda automatically processes messages from the queue, while the DLQ stores messages that failed processing for inspection and reprocessing.
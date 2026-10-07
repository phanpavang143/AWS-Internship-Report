---
title: "Amazon SQS, AWS Lambda, CloudWatch and CloudTrail"
date: 2026-08-30
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---

## Step 1: Create an Amazon SQS queue
● Go to the AWS Console → SQS → Create queue.
● Select Standard Queue.
● Name it: webdemo-events.
● Configure the Visibility Timeout and Message Retention settings appropriately.
![AWS Illustration](/images/5-Workshop/5.5-Policy/SQS.jpg)
ECS application sends events to the Queue:
ECS Fargate
     │
     ▼
Amazon SQS
     │
     ▼
Event Processing

## Step 2: Create AWS Lambda
● Go to AWS Console → Lambda → Create function.
● Select "Author from scratch".
● Select the runtime appropriate for the processing application.
● Assign an IAM Role with the necessary permissions.
![AWS Illustration](/images/5-Workshop/5.5-Policy/Lambda.jpg)
Lambda can be triggered when a new message arrives in SQS:
ECS → SQS → Lambda
              │
              ▼
         Process Event
Upon successful processing, the message is handled by Lambda and removed from the queue in accordance with the event source mapping mechanism.

## Step 3: Configure CloudWatch
Go to: AWS Console → CloudWatch
Monitor:
● ECS CPU/Memory.
● ALB Request Count and Responses.
● RDS CPU/Database Connections.
● SQS message count.
● Lambda Invocations and Errors.
● Application Logs.
![AWS Illustration](/images/5-Workshop/5.5-Policy/CloudWatch.jpg)
Create a CloudWatch Alarm to trigger an alert when a metric exceeds a threshold.
ECS ─┐
ALB ─┤
RDS ─┤──> CloudWatch ──> Alarm
SQS ─┤
Lambda ┘

## Step 4: Configure CloudTrail
Go to: AWS Console → CloudTrail → Trails → Create trail
CloudTrail records API activity within the AWS account, supporting:
● Monitoring administrative actions.
● Auditing API call history.
● Facilitating security event auditing and tracing.
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

## Step 5: IAM Permissions
Create dedicated IAM roles for each component:
ECS Task Role
   ├── SQS SendMessage
   └── S3 Access

Lambda Execution Role
   ├── SQS ReceiveMessage
   └── CloudWatch Logs

Grant only the necessary permissions, adhering to the principle of least privilege.

## Step 6: System Verification
Trigger an event from the application:
ECS
 ↓
SQS
 ↓
Lambda
 ↓
CloudWatch Logs

Then verify the following:
● The message appears in SQS.
● The Lambda function is invoked.
● The Lambda function processes successfully.
● Logs appear in CloudWatch.
● AWS activities are recorded in CloudTrail.

## Outcome:
SQS and Lambda establish an event-driven/asynchronous processing mechanism, decoupling background tasks from the main request flow. CloudWatch handles monitoring and logging, while CloudTrail provides an audit trail of AWS activities, ensuring comprehensive system operation and monitoring capabilities.
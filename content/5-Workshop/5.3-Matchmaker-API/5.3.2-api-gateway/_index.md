---
title: "ALB health checks and autoscaling"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.3.2. </b> "
---

## Step 1: Configure ALB Health Check
Go to: EC2 → Target Groups → select the ECS Target Group → Health checks
Settings:
Protocol: HTTP
Port: Traffic Port (8080)
Path: /
Healthy threshold: 2
Unhealthy threshold: 3
Timeout: 5 seconds
Interval: 30 seconds
![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/HealthCheck.jpg)

## Step 2: Check Target status
Under Target Groups → Targets, check the status: ECS Task → Healthy
If the Task switches to Unhealthy, the ALB will stop sending traffic to that Task.

## Step 3: Enable ECS Service Auto Scaling
Go to: ECS → Cluster → Service → Update → Auto Scaling
Configure the number of Tasks:
Minimum: 1
Desired: 2
Maximum: 4
![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/AutoScaling.jpg)

## Step 4: Configure Scaling Policy
Select "Target Tracking" and use a CloudWatch metric, for example:
ECSServiceAverageCPUUtilization
Target: 60%
When average CPU usage rises, ECS can increase the number of tasks. When the load decreases, ECS reduces the number of tasks in accordance with the Auto Scaling policy.

## Step 5: Verify Operation
● Access the application via the ALB DNS.
● Check the Target Group → Targets.
● Monitor CPU/Memory metrics in CloudWatch.
● Observe the ECS task count as the load changes.
Operational Model
                Internet
                    │
                    ▼
              ┌───────────┐
              │    ALB    │
              └─────┬─────┘
                    │
          Health Check :8080
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
     ECS Task 1  ECS Task 2  ECS Task 3
        │           │           │
        └───────────┼───────────┘
                    │
              Auto Scaling
                    │
              CloudWatch

## Result:
The ALB ensures traffic is routed only to active ECS tasks. Auto Scaling enables the service to automatically adjust the number of tasks based on load, supporting the application's high availability and horizontal scaling capabilities.

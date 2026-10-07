---
title: "AWS infrastructure cleanup and cost control"
date: 2026-08-30
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

## Step 1: Check resources currently in use
Go to: AWS Console → Resource Explorer / AWS services
Check the following resources:
● ECS / Fargate
● RDS MySQL
● S3
● CloudFront
● ElastiCache Redis
● SQS
● Lambda
● ALB
● CloudWatch
● NAT Gateway

## Step 2: Delete ECS and Load Balancer
Go to: ECS → Clusters → select cluster → Delete
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/ESCCulers.jpg)
Then check:
EC2 → Load Balancers
Delete the ALB that is no longer in use.
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

## Step 3: Delete RDS and ElastiCache
Go to: RDS → Databases → select database → Actions → Delete
Then: ElastiCache → Redis caches → Delete
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/DLec.jpg)

## Step 4: Check S3 and CloudFront
Go to: S3 → Buckets
Delete any buckets that are no longer in use.
Then:
CloudFront → Distributions
Disable and delete any unnecessary distributions.

## Step 5: Check NAT Gateway and Elastic IP
Go to: VPC → NAT Gateways
Delete any unused NAT Gateways.
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/DLNat.jpg)

## Step 6: Check costs
Go to: AWS Console → Billing and Cost Management → Cost Explorer
Check costs by:
● Service.
● Region.
● Day/Month.
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/Cost.jpg)

## Step 7: Create a cost alert
Go to: Billing → Budgets → Create budget
AWS Cost
    │
    ▼
Budget $10
    │
    ├── 80% → Warning
    │
    └── 100% → Alert

## Step 8: Final check
Ensure test resources have been cleaned up:
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
Cleanup Architecture
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

## Outcome:
Cleanup helps remove unused AWS resources—specifically RDS, NAT Gateways, ALBs, ElastiCache, and Elastic IPs. Combining Cost Explorer with AWS Budgets enables cost monitoring and control, helping to prevent unexpected expenses.
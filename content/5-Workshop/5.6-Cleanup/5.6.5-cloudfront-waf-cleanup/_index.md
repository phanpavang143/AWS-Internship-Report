---
title: "Safe Terraform destroy and cost verification"
date: 2026-08-30
weight: 5
chapter: false
pre: " <b> 5.6.5. </b> "
---

## Step 1: Check resources before destruction
Run: `terraform plan`
Review the resources to be deleted:

Terraform
   │
   ▼
terraform plan
   │
   ▼
Resource list:
   │
   ├── ECS
   ├── RDS
   ├── S3
   ├── Redis
   ├── ALB
   └── NAT Gateway

## Step 2: Back up critical data
Before destruction:
● RDS: Create a DB snapshot.
● S3: Back up/download files that need to be retained.
● Check the Terraform state.

RDS ─────► Snapshot
S3  ─────► Backup
              │
              ▼
        Terraform Destroy

## Step 3: Destroy infrastructure
After confirmation: `terraform destroy`
Terraform will display the list of resources and request confirmation:
Plan: 0 to add,
      0 to change,
      X to destroy.
Do you really want to destroy all resources?
Enter a value: yes

## Step 4: Check for remaining resources
Go to the AWS Console to check:
ECS
RDS
ElastiCache
S3
ALB
NAT Gateway
Elastic IP
CloudFront
SQS
Lambda
CloudWatch

## Step 5: Check AWS costs
Go to: AWS Console → Billing and Cost Management → Cost Explorer
Select:
● Time range: Last 7 days / Last 30 days.
● Group by: Service.
AWS Billing
     │
     ▼
Cost Explorer
     │
     ▼
Costs by Service
     │
     ├── ECS
     ├── RDS
     ├── NAT Gateway
     ├── S3
     └── CloudFront
Overall Architecture
Terraform
    │
    ▼
terraform plan
    │
    ▼
Data backup
    │
    ▼
terraform destroy
    │
    ▼
AWS Resources ──► Check for remaining resources
    │
    ▼
Cost Explorer
    │
    ▼
Cost control

## Result:
Terraform is used to check → backup → destroy → verify remaining resources → check costs, helping to prevent the accidental deletion of critical data and minimize unexpected AWS costs.

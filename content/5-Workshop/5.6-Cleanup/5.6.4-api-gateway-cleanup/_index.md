---
title: "VPC endpoints and NAT Gateway"
date: 2026-08-30
weight: 4
chapter: false
pre: " <b> 5.6.4. </b> "
---

## Step 1: Create NAT Gateway
Go to: AWS Console → VPC → NAT Gateways → Create NAT Gateway
●Select Public Subnet.
●Connectivity type: Public.
●Assign Elastic IP.
Private Subnet
      │
      ▼
 NAT Gateway
      │
      ▼
 Internet Gateway
      │
      ▼
  Internet

## Step 2: Configure Route Table for Private Subnet
Go to: VPC → Route Tables → Private Route Table → Routes
More:
0.0.0.0/0
    │
    ▼
NAT Gateway
Step 3: Create VPC Endpoint for S3
Go to: VPC → Endpoints → Create endpoint
●Service category: AWS services
●Service: S3
●Type: Gateway
●Select VPC webdemo-vpc.
●Select Route Table of Private Subnet.
![AWS cleanup illustration](/images/5-Workshop/5.6-Cleanup/EntpointST.jpg)

ECS Fargate
     │
     ▼
Private Subnet
     │
     ▼
VPC Endpoint
     │
     ▼
     S3

## Step 4: Verify Connectivity
Verify that the ECS instance can:
● Access the Internet via the NAT Gateway.
● Access S3 via the VPC Endpoint.
● Operate without a Public IP for the ECS Task.
                ┌──► NAT Gateway ──► Internet
ECS Fargate ─────┤
                 └──► VPC Endpoint ──► S3

## Results
The NAT Gateway provides Internet access for resources in the Private Subnet, while the VPC Endpoint allows ECS to access S3 via the AWS network without traversing the Internet. This deployment approach enables WebDemo to keep ECS within the Private Subnet, thereby enhancing the architecture's security.

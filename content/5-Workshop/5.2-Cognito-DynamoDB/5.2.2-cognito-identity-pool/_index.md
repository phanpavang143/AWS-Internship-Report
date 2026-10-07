---
title: "Subnets, security groups and VPC endpoints"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.2.2. </b> "
---

## Step 1: Create a VPC
● Go to AWS Console → VPC → Your VPCs → Create VPC.
● Name: webdemo-vpc.
● IPv4 CIDR: 10.0.0.0/16.
● Region: Asia Pacific (Singapore) – ap-southeast-1.

## Step 2: Create Public and Private Subnets
Create subnets across at least two Availability Zones:
![Tạo Subnet](/images/5-Workshop/5.2-Prerequisite/TaoSubnet.jpg)

## Step 3: Create Security Groups
Create separate Security Groups for each tier:
● ALB-SG: Allow HTTP (80) and HTTPS (443) from the Internet.
● ECS-SG: Allow only port 8080 from ALB-SG.
● RDS-SG: Allow only MySQL (3306) from ECS-SG.
Traffic flow model:
Internet
   ↓ 80/443
ALB-SG
   ↓ 8080
ECS-SG
   ↓ 3306
RDS-SG

## Step 4: Create VPC Endpoints
Go to AWS Console → VPC → Endpoints → Create endpoint.
● Amazon S3 – Access S3 from the Private Subnet.
● ECR API – ECS communication with Amazon ECR.
● ECR DKR – Pull Docker images from ECR.
● CloudWatch Logs – Send logs from ECS to CloudWatch.
![Tạo VPC Entpoint](/images/5-Workshop/5.2-Prerequisite/VPCEntPoint.jpg)

## Step 5: Verify connectivity
Check the following:
● The ALB is located in a public subnet.
● The ECS service is located in a private subnet.
● The RDS instance is located in a private subnet.
● Security groups allow only necessary traffic flows.
● The ECS service can access required AWS services via VPC Endpoints.

## Result:
The network architecture is segmented into public and private layers; security groups control traffic between components; and VPC Endpoints enable the ECS service in the private subnet to access necessary AWS services without exposing application resources directly to the public.

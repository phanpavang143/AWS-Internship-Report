---
title: "Terraform, VPC, private subnets and network security"
date: 2026-09-25
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

1. Initialize Terraform
Create a Terraform directory and configure the AWS Region:
provider "aws" {
  region = "ap-southeast-1" }
Run: terraform init

2. Create a VPC
Go to AWS Console → VPC → Your VPCs → Create VPC.
● Name: webdemo-vpc
● IPv4 CIDR: 10.0.0.0/16
![Create VPC](/images/5-Workshop/5.2-Prerequisite/VPC.jpg)

3. Create Subnets
Go to VPC → Subnets → Create subnet.
Create:
● 2 Public Subnets → for the ALB.
● 2 Private Subnets → for ECS and RDS.
● Place them across 2 Availability Zones.

4. Create an Internet Gateway
Go to VPC → Internet Gateways → Create, then attach it to `webdemo-vpc`.
The Internet Gateway serves only the Public Subnets.
![Internet Gateway](/images/5-Workshop/5.2-Prerequisite/InternetGateway.jpg)

5. Route Table Configuration
Create a Public Route Table and add the route: 0.0.0.0/0 → Internet Gateway.
Associate the Route Table with the two Public Subnets. Private Subnets do not route directly through the Internet Gateway.

6. Create Security Groups
Set up traffic flow: Internet → ALB → ECS → RDS
           80/443  8080  3306
● ALB: Allow ports 80/443 from the Internet.
● ECS: Allow only port 8080 from the ALB.
● RDS: Allow only port 3306 from the ECS.
● Do not expose RDS port 3306 to 0.0.0.0/0.

7. Deployment with Terraform
Validate and deploy: `terraform validate`, `terraform plan`, `terraform apply`.

8. Security Verification
In the VPC Console, verify the following:
● ECS and RDS are located in Private Subnets.
● ALB is located in Public Subnets.
● RDS is not directly accessible from the Internet.
Security Groups expose only the necessary ports.
![Security check](/images/5-Workshop/5.2-Prerequisite/Kiemtrabaomat.jpg)

## Result: Successfully built an AWS network based on the Internet → ALB → ECS → RDS architecture, with ECS and RDS secured within private subnets and infrastructure managed using Terraform.



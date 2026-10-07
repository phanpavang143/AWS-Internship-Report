---
title: "Environment, AWS Region and deployment tools"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---
## 1. Prepare AWS Account
Log in to the AWS Management Console and ensure the account has permission to use the necessary services.

## 2. Select AWS Region
In the top-right corner of the AWS Console, select: Asia Pacific (Singapore) (ap-southeast-1).
![Select Region](/images/5-Workshop/5.1-Workshop-overview/ChonRegion.jpg)

## 3. Prepare Java and Maven
Install Java 25 and Maven to build the Spring Boot application. Verify: `java -version`, `mvn -version`

## 4. Prepare Git and Source Code
Install Git, clone the WebDemo project, and check the source code: `git clone <repository>`, `cd WebDemo`

## 5. Install Docker
Install Docker Desktop and verify: `docker --version`
Test build the Docker image: `docker build -t webdemo:latest .`

## 6. Configure AWS CLI
Install and configure AWS CLI: `aws configure`
Select Region: `ap-southeast-1`
Verify connection: `aws sts get-caller-identity`

## 7. Install Terraform
Install Terraform and verify: `terraform version`
Initialize: `terraform init`

## 8. Verify the entire environment
Ensure WebDemo runs locally, Docker is operational, AWS CLI connects successfully, and Terraform initializes correctly before creating the AWS infrastructure.
![Engineer ](/images/5-Workshop/5.1-Workshop-overview/Engineer.jpg)

---
title: "Docker, Amazon ECS Fargate and Application Load Balancer"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

The Application Load Balancer (ALB) receives requests from users and distributes traffic to ECS tasks in the private subnet.
![Diagram](/images/5-Workshop/5.3-S3-vpc/Sodo.jpg)

## 1. Create Docker Image
Build the application: `mvn clean package`, `docker build -t webdemo:latest .`
Verify: `docker images`
## 2. Create Amazon ECR Repository
Go to AWS Console → ECR → Repositories → Create repository.
Name it: `webdemo`
Then, push the Docker image to ECR so that ECS can use it.
![ERCRepository](/images/5-Workshop/5.3-S3-vpc/ERCRepository.jpg)

## 3. Create ECS Cluster
Go to: AWS Console → ECS → Clusters → Create
Select AWS Fargate (Serverless) and name it: webdemo-cluster
![ECSCluster](/images/5-Workshop/5.3-S3-vpc/ESCCluster.jpg)

## 4. Create ECS Task Definition
Go to ECS → Task Definitions → Create.
Select:
● Launch type: Fargate
● Container image: Docker image from ECR
● Container port: 8080
● CPU/Memory: Select based on application requirements.
![ECSTask](/images/5-Workshop/5.3-S3-vpc/ESCTask.jpg)

## 5. Create an Application Load Balancer
Go to: EC2 → Load Balancers → Create Load Balancer → Application Load Balancer
Configuration:
● Scheme: Internet-facing
● Select 2 public subnets.
● Attach `webdemo-alb-sg`.
The ALB will receive requests from the Internet.
![LoadBalancer](/images/5-Workshop/5.3-S3-vpc/LoadBalancer.jpg)

## 6. Create Target Group
Create a Target Group for ECS:
Target type: IP
Protocol: HTTP
Port: 8080
Health check: /
Then, associate the Target Group with the ECS Service.
![TagetGroup](/images/5-Workshop/5.3-S3-vpc/TagetGroup.jpg)

## 7. Create ECS Service
In the ECS Cluster: Services → Create
Configuration:
● Launch type: Fargate
● Select Private Subnet.
● Attach webdemo-ecs-sg.
● Select the ALB Target Group.
● Set the desired number of tasks.
![ECSService](/images/5-Workshop/5.3-S3-vpc/ESCService.jpg)

## Workflow:
User
  │
  ▼
ALB: 80/443
  │
  ▼
ECS Fargate: 8080
  │
  ├── RDS
  ├── S3
  └── SQS

## 8. System Verification
Navigate to: ECS → Cluster → Service → Tasks
Verify that the Task status is: RUNNING
Then, retrieve the ALB DNS name and access it via a browser to check the application.
Additionally, check Target Group → Targets to ensure the ECS Task status is: Healthy

## Result: WebDemo is deployed using the following model:
Docker → ECR → ECS Fargate → ALB, where the ALB is located in a Public Subnet and ECS Fargate runs in a Private Subnet; this setup allows the application to receive traffic from the Internet while restricting direct access to the container.

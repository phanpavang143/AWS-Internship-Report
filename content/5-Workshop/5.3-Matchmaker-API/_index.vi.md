---
title: "Docker, Amazon ECS Fargate và Application Load Balancer"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

## Application Load Balancer (ALB) nhận request từ người dùng và phân phối traffic đến các ECS Task trong Private Subnet.
![Sơ đồ](/images/5-Workshop/5.3-S3-vpc/Sodo.jpg)

## 1. Tạo Docker Image
Build ứng dụng: mvn clean package, docker build -t webdemo:latest .
Kiểm tra: docker images
## 2. Tạo Amazon ECR Repository
Vào AWS Console → ECR → Repositories → Create repository.
Đặt tên: webdemo
Sau đó push Docker Image lên ECR để ECS có thể sử dụng.
![ERCRepository](/images/5-Workshop/5.3-S3-vpc/ERCRepository.jpg)

## 3. Tạo ECS Cluster
Vào: AWS Console → ECS → Clusters → Create
Chọn AWS Fargate (Serverless) và đặt tên: webdemo-cluster
![ECSCluster](/images/5-Workshop/5.3-S3-vpc/ESCCluster.jpg)

## 4. Tạo ECS Task Definition
Vào ECS → Task Definitions → Create.
Chọn:
●Launch type: Fargate
●Container image: Docker Image từ ECR
●Container port: 8080
●CPU/Memory: chọn theo nhu cầu ứng dụng.
![ECSTask](/images/5-Workshop/5.3-S3-vpc/ESCTask.jpg)

## 5. Tạo Application Load Balancer
Vào: EC2 → Load Balancers → Create Load Balancer → Application Load Balancer
Cấu hình:
●Scheme: Internet-facing
●Chọn 2 Public Subnet.
●Gắn webdemo-alb-sg.
ALB sẽ tiếp nhận request từ Internet.
![LoadBalancer](/images/5-Workshop/5.3-S3-vpc/LoadBalancer.jpg)

## 6. Tạo Target Group
Tạo Target Group cho ECS:
Target type: IP
Protocol: HTTP
Port: 8080
Health check: /
Sau đó liên kết Target Group với ECS Service.
![TagetGroup](/images/5-Workshop/5.3-S3-vpc/TagetGroup.jpg)

## 7. Tạo ECS Service
Trong ECS Cluster: Services → Create
Cấu hình:
●Launch type: Fargate
●Chọn Private Subnet.
●Gắn webdemo-ecs-sg.
●Chọn Target Group của ALB.
●Thiết lập số lượng Task mong muốn.
![ECSService](/images/5-Workshop/5.3-S3-vpc/ESCService.jpg)

## Luồng hoạt động:
User
  │
  ▼
 ALB : 80/443
  │
  ▼
ECS Fargate : 8080
  │
  ├── RDS
  ├── S3
  └── SQS

## 8. Kiểm tra hệ thống
Vào: ECS → Cluster → Service → Tasks
Kiểm tra Task có trạng thái: RUNNING
Sau đó lấy DNS name của ALB và truy cập bằng trình duyệt để kiểm tra ứng dụng.
Kiểm tra thêm Target Group → Targets để đảm bảo ECS Task có trạng thái: Healthy

## Kết quả: WebDemo được triển khai theo mô hình:
Docker → ECR → ECS Fargate → ALB, trong đó ALB nằm ở Public Subnet, còn ECS Fargate chạy trong Private Subnet, giúp ứng dụng vừa có khả năng nhận traffic từ Internet vừa hạn chế truy cập trực tiếp đến container.




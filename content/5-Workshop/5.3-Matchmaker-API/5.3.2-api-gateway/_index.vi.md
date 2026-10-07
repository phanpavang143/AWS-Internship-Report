---
title: "ALB health check và autoscaling"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.3.2. </b> "
---

## Bước 1: Cấu hình ALB Health Check
Vào: EC2 → Target Groups → chọn Target Group của ECS → Health checks
Thiết lập:
Protocol: HTTP
Port: Traffic Port (8080)
Path: /
Healthy threshold: 2
Unhealthy threshold: 3
Timeout: 5 seconds
Interval: 30 seconds
![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/HealthCheck.jpg)

## Bước 2: Kiểm tra trạng thái Target
Trong Target Groups → Targets, kiểm tra trạng thái: ECS Task → Healthy
Nếu Task chuyển sang Unhealthy, ALB sẽ ngừng gửi traffic đến Task đó.

## Bước 3: Bật ECS Service Auto Scaling
Vào: ECS → Cluster → Service → Update → Auto Scaling
Thiết lập số lượng Task:
Minimum: 1
Desired: 2
Maximum: 4
![Minh họa AWS](/images/5-Workshop/5.3-S3-vpc/AutoScaling.jpg)

## Bước 4: Cấu hình Scaling Policy
Chọn Target Tracking và sử dụng một CloudWatch metric, ví dụ:
ECSServiceAverageCPUUtilization
Target: 60%
Khi CPU trung bình tăng cao, ECS có thể tăng số lượng Task. Khi tải giảm, ECS giảm Task theo chính sách Auto Scaling.

## Bước 5: Kiểm tra hoạt động
●Truy cập ứng dụng thông qua ALB DNS.
●Kiểm tra Target Group → Targets.
●Theo dõi CPU/Memory tại CloudWatch.
●Kiểm tra số lượng ECS Task khi tải thay đổi.
Mô hình hoạt động
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

## Kết quả:
ALB đảm bảo traffic chỉ được chuyển đến các ECS Task đang hoạt động. Auto Scaling giúp dịch vụ tự điều chỉnh số lượng Task theo tải, hỗ trợ khả năng High Availability và horizontal scaling của ứng dụng.



---
title: "Redis cho session dùng chung"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.4.3. </b> "
---

## Bước 1: Tạo ElastiCache Redis
●Vào AWS Console → ElastiCache → Redis.
●Tạo Redis trong Private Subnet.
●Security Group chỉ cho phép ECS-SG truy cập port 6379.
![Minh họa AWS](/images/5-Workshop/5.4-S3-onprem/ElastiCache.jpg)
ECS Task ──6379──> ElastiCache Redis

## Bước 2: Thêm Redis vào Spring Boot
Thêm dependency:
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session-data-redis</artifactId>
</dependency>

Cấu hình kết nối Redis:
spring.data.redis.host=${REDIS_HOST}
spring.data.redis.port=6379
spring.session.store-type=redis

## Bước 3: Lưu Session trên Redis
Khi người dùng đăng nhập:
User
  ↓
ALB
  ↓
ECS Task 1
  ↓
Redis
Session được lưu trên Redis thay vì chỉ lưu trong bộ nhớ của Task 1.

## Bước 4: Chia sẻ Session giữa các Task
Khi ALB chuyển request tiếp theo sang Task 2:
            ALB
            /   \
           ▼     ▼
      ECS Task 1  ECS Task 2
           \       /
            ▼     ▼
          Redis
        Shared Session
Task 2 có thể đọc Session từ Redis và tiếp tục xử lý request của người dùng.

## Bước 5: Kiểm tra hoạt động
●Đăng nhập vào ứng dụng.
●Gửi nhiều request liên tiếp.
●Kiểm tra Session vẫn được duy trì khi request được phân phối đến các ECS Task khác nhau.
●Kiểm tra kết nối giữa ECS và Redis.
Bước 6: Kết hợp với Auto Scaling
Khi ECS tăng từ 1 lên nhiều Task:
                   ALB
                 /   |   \
                ▼    ▼    ▼
             ECS-1 ECS-2 ECS-3
                \    |    /
                 ▼   ▼   ▼
                Redis
          Shared Session
Session không phụ thuộc vào một Task cụ thể, phù hợp với mô hình horizontal scaling.

## Kết quả:
Redis đóng vai trò Session Store tập trung, giúp các ECS Task dùng chung trạng thái phiên đăng nhập. Điều này hỗ trợ hệ thống hoạt động ổn định khi ALB phân phối request và khi ECS Auto Scaling tăng số lượng Task.


---
title: "Redis for shared sessions"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.4.3. </b> "
---

## Step 1: Create ElastiCache Redis
● Go to AWS Console → ElastiCache → Redis.
● Create the Redis instance in a private subnet.
● Configure the security group to allow access to port 6379 only from ECS-SG.
![AWS Illustration](/images/5-Workshop/5.4-S3-onprem/ElastiCache.jpg)
ECS Task ──6379──> ElastiCache Redis

## Step 2: Add Redis to Spring Boot
Add the dependency:
<dependency>
    <groupId>org.springframework.session</groupId>
    <artifactId>spring-session-data-redis</artifactId>
</dependency>

Configure the Redis connection:
spring.data.redis.host=${REDIS_HOST}
spring.data.redis.port=6379
spring.session.store-type=redis

## Step 3: Store Session in Redis
When a user logs in:
User
  ↓
ALB
  ↓
ECS Task 1
  ↓
Redis
The session is stored in Redis instead of just in Task 1's memory.

## Step 4: Sharing Sessions Across Tasks
When the ALB routes the next request to Task 2:
            ALB
            /   \
           ▼     ▼
      ECS Task 1  ECS Task 2
           \       /
            ▼     ▼
          Redis
        Shared Session
Task 2 can read the session from Redis and continue processing the user's request.

## Step 5: Verification
● Log in to the application.
● Send multiple consecutive requests.
● Verify that the session is maintained as requests are distributed to different ECS Tasks.
● Check the connection between ECS and Redis.
Step 6: Integration with Auto Scaling
When ECS scales from a single task to multiple tasks:
                   ALB
                 /   |   \
                ▼    ▼    ▼
             ECS-1 ECS-2 ECS-3
                \    |    /
                 ▼   ▼   ▼
                Redis
          Shared Session
The session is not tied to a specific task, making it suitable for a horizontal scaling model.

## Result:
Redis acts as a centralized session store, allowing ECS ​​Tasks to share session state. This ensures system stability as the ALB distributes requests and ECS Auto Scaling increases the number of tasks.
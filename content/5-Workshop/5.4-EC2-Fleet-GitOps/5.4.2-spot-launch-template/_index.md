---
title: "S3 and CloudFront for images"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 5.4.2. </b> "
---

## Step 1: Create an S3 Bucket
● Go to AWS Console → S3 → Create bucket.
● Set the name: webdemo-product-images.
● Select Region: ap-southeast-1.
● Enable "Block all public access" to prevent the bucket from being directly public.
![AWS Illustration](/images/5-Workshop/5.4-S3-onprem/S3Bucket.jpg)

## Step 2: Grant permissions to the application
ECS uses an IAM Role to upload and read images from S3.
ECS Fargate ── IAM Role ──> S3

## Step 3: Upload product images
The Spring Boot application receives images from the Admin and uploads them to S3:
Admin
  ↓
Spring Boot / ECS
  ↓
Amazon S3
  ↓
Product Image

## Step 4: Create a CloudFront Distribution
Go to: AWS Console → CloudFront → Create distribution
● Select the S3 bucket as the Origin.
● Use HTTPS.
● Configure a Cache Policy suitable for image content.
● Use the CloudFront URL to distribute the images.
![AWS Illustration](/images/5-Workshop/5.4-S3-onprem/Distribution.jpg)
## Traffic Flow:
User
  ↓
CloudFront
  ↓
S3

Step 5: Security Configuration
Public access to S3 does not need to be enabled. CloudFront is configured to access the S3 origin using an appropriate access control mechanism.
Internet
   │
   ▼
CloudFront
   │
   ▼
Private S3 Bucket

## Step 6: Testing and Optimization
● Upload a product image to S3.
● Access the image via CloudFront.
● Verify successful content delivery by CloudFront.
● Monitor cache status and request volume.
● When updating an image with the same filename, perform an invalidation or use a new object name/version to avoid serving stale cache content.

## Outcome:
S3 handles durable image storage, while CloudFront manages image delivery to users via the CDN. The ECS application does not need to directly serve all image files, thereby reducing the load on Spring Boot and improving system scalability.

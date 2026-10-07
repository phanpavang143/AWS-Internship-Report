---
title: "Build the image and ECS service"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.3.1. </b> "
---

## Step 1: Build the application
In the source directory: `mvn clean package`
Verify the generated .jar file in the `target/` directory.

## Step 2: Build the Docker image
`docker build -t webdemo:latest .`
Verify the image: `docker images`.

## Step 3: Push the image to Amazon ECR
● Go to AWS Console → ECR → Repositories → Create repository.
● Create repository: `webdemo`.
● Log in to ECR via Docker.
● Tag the image and push:
![AWS Illustration](/images/5-Workshop/5.3-S3-vpc/AmazonECR.jpg)

docker tag webdemo:latest <ECR_URI>:latest
docker push <ECR_URI>:latest
Then check the image in ECR → webdemo → Images.

## Step 4: Create a Secret
Go to: AWS Console → Secrets Manager → Store a new secret
![AWS Illustration](/images/5-Workshop/5.3-S3-vpc/Secret.jpg)

## Step 5: Granting Permissions to ECS
In the ECS Task Definition, configure the container to use the secret from Secrets Manager.
The Task Execution Role and Task Role must be granted the appropriate permissions to allow ECS to access the secret.

## Step 6: Verifying the Deployment
Verify the following:
● The Docker image is available in ECR.
● The ECS Task pulls the correct image from ECR.
● ECS successfully reads the secret.
● The database connection is functional.
● No passwords appear in the source code or Git repository.

## Outcome:
Docker standardizes the application runtime environment, Amazon ECR stores the image, and AWS Secrets Manager protects sensitive information. ECS Fargate can utilize this image and these secrets to deploy the application securely.

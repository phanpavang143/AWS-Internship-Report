---
title: "Terraform backend and environment variables"
date: 2026-08-30
weight: 1
chapter: false
pre: " <b> 5.2.1. </b> "
---

## Step 1: Create an S3 Bucket to store Terraform State
●Go to AWS Console → S3 → Create bucket.
●Name the bucket: webdemo-terraform-state.
●Select Region: Asia Pacific (Singapore) – ap-southeast-1.
●Enable "Block all public access."
●Enable Bucket Versioning to allow recovery of previous state versions.
![Minh họa AWS](/images/5-Workshop/5.2-Prerequisite/S3.jpg)

## Step 2: Configure Terraform Backend
In backend.tf:
terraform {
  backend "s3" {
    bucket = "webdemo-terraform-state"
    key    = "webdemo/terraform.tfstate"
    region = "ap-southeast-1" }
}

Initialize the backend: terraform init

## Step 3: Declare environment variables
In `variables.tf`:
variable "db_username" {
  type      = string
  sensitive = true }
variable "db_password" {
  type      = string
  sensitive = true }

In Windows PowerShell:
$env:TF_VAR_db_username="admin"
$env:TF_VAR_db_password="your-password"

## Step 4: Exclude sensitive information from GitHub
Add to `.gitignore`:
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
.env

## Step 5: Validate and deploy
terraform init
terraform validate
terraform plan
terraform apply

## Check State: terraform state list
After deployment, check Amazon S3 to confirm that the `terraform.tfstate` file has been stored.

## Result:
Terraform State is centrally managed on Amazon S3, while configuration details and sensitive data are passed via Environment Variables/Secrets, enhancing security and convenience when deploying across multiple environments.

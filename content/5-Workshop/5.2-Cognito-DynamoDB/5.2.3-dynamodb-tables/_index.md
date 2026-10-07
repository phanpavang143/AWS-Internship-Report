---
title: "State, outputs and secrets"
date: 2026-08-30
weight: 3
chapter: false
pre: " <b> 5.2.3. </b> "
---

## 1. Terraform State Management
File created: `terraform.tfstate`
This file stores the Terraform infrastructure state. Do not push the State file to GitHub, as it may contain sensitive information.

## 2. Output Declaration
Create `outputs.tf` to display necessary information:
```hcl
output "vpc_id" {
  value = aws_vpc.main.id }
output "rds_endpoint" {
  value = aws_db_instance.mysql.address }
```
After deployment, run: `terraform output`
Terraform will display the output values ​​for use in subsequent steps.

## 3. Secrets Management
● Database username/password.
● Secret key.
● Other sensitive configuration information.
On the AWS Console: AWS Secrets Manager → Store a new secret → select secret type → enter values ​​→ save the secret.

## 4. Protecting Sensitive Files
Add the following to `.gitignore`:
`.terraform/`
`*.tfstate`
`*.tfstate.*`
`*.tfvars`
`.env`

## 5. Verification
After configuration, run: `terraform plan`, `terraform apply`, `terraform output`
![AWS Illustration](/images/5-Workshop/5.2-Prerequisite/Kiemtra1.jpg)
![AWS Illustration](/images/5-Workshop/5.2-Prerequisite/Kiemtra2.jpg)
![AWS Illustration](/images/5-Workshop/5.2-Prerequisite/Kiemtra3.jpg)

## Result: The Terraform state is securely managed, outputs provide the necessary information for subsequent deployment steps, and secrets are stored separately rather than appearing directly in the source code.

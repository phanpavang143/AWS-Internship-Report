---
title: "Data security and backups"
date: 2026-08-30
weight: 4
chapter: false
pre: " <b> 5.4.4. </b> "
---

## Step 1: Secure RDS MySQL
● Place the RDS instance in a private subnet.
● Disallow direct access from the Internet.
● Configure the Security Group to allow traffic only from ECS-SG to RDS on port 3306.
● Enable data encryption during RDS creation if required by system specifications.
Internet
   X
   │
Private Subnet
   │
ECS ──3306──> RDS MySQL

## Step 2: Backup RDS
Go to: AWS Console → RDS → Databases → Select Database → Modify
Configure Automated Backups and an appropriate retention period.
RDS supports Point-in-Time Recovery, allowing the database to be restored to a specific point in time within the backup retention window.

## Step 3: Protect Data on S3
● Enable Block Public Access.
● Use an IAM Role for ECS to access S3.
● Enable Versioning to retain object versions.
● Optionally use a Lifecycle Policy to manage older data.
ECS → IAM Role → S3
                  │
               Versioning

## Step 4: Protecting Secrets
Use AWS Secrets Manager to store:
● RDS username/password.
● Redis credentials (if applicable).
● Other sensitive configuration information.
The ECS Task uses an IAM Role to retrieve secrets instead of hardcoding passwords in the source code.

## Step 5: Controlling Access
Apply the Principle of Least Privilege:
ALB → ECS
ECS → RDS
ECS → S3
ECS → Redis
Each component is granted only the permissions necessary for its specific function.

## Step 6: Verifying Recoverability
Conduct periodic checks:
● Restore RDS from a snapshot.
● Test Point-in-Time Recovery.
● Restore S3 object versions.
● Verify secret accessibility after redeploying ECS.

## Outcome:
Data is protected through multiple layers—Network, IAM, Encryption, and Secrets—while RDS backups, snapshots, and S3 versioning enhance data recoverability in the event of an incident.
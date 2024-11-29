# AWS VPC Creation - Homework 3

This project automates the creation of AWS VPC resources as part of Homework 3.

## Overview

The goal is to set up a Virtual Private Cloud (VPC) in AWS with:

- Two subnets: one public and one private.
- Two security groups:
  - `sg-FRONT`: For SSH access to the WEB instance.
  - `sg-BACK`: For internal communication with the DB instance.
- Two EC2 instances:
  - `WEB`: Located in the public subnet.
  - `DB`: Located in the private subnet with access through the WEB instance as a jump host.

---

## File Structure

- `awscli/`
  - `VPC.md`: Step-by-step documentation of the commands and configuration.
  - `script.sh`: Bash script to automate the creation of all resources.
- `README.md`: This file, providing an overview and instructions.

---

## Prerequisites

1. **AWS Account** with access to the AWS CLI and appropriate IAM permissions.
2. **AWS CLI** installed and configured:
   ```bash
   aws configure
   ```
3. Replace placeholder values (e.g., `192.168.0.0/24`, `MyMain`, `ami-1284a47cc718c13`) with your specific values.

---

## Steps to Execute

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd awscli
   ```
2. Run the script:
   ```bash
   bash script.sh
   ```
3. Verify resources using commands such as:
   ```bash
   aws ec2 describe-vpcs
   aws ec2 describe-subnets
   aws ec2 describe-instances
   ```

---

## Notes

- Ensure proper cleanup of resources after testing to avoid unexpected charges:
  ```bash
  aws ec2 terminate-instances --instance-ids <instance-id>
  aws ec2 delete-subnet --subnet-id <subnet-id>
  aws ec2 delete-vpc --vpc-id <vpc-id>
  ```
- For more details, refer to `VPC.md`.

---

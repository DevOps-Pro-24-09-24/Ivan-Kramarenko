# Terraform AWS Infrastructure: Homework 6

This project is a Terraform configuration for setting up basic AWS infrastructure as part of a DevOps assignment. The configuration includes a VPC, two subnets, security groups, and EC2 instances, designed to meet the specified requirements.

## Features

1. **VPC**:

   - CIDR block: `192.168.0.0/24`.
   - Two subnets:
     - **Public subnet**: Allows internet access.
     - **Private subnet**: No internet access.

2. **Security Groups**:

   - **sg-FRONT**:
     - Inbound: TCP 22 (SSH), TCP 80 (HTTP), TCP 443 (HTTPS).
     - Outbound: All traffic.
   - **sg-BACK**:
     - Inbound: Only traffic from `sg-FRONT`.
     - Outbound: All traffic.

3. **EC2 Instances**:

   - **WEB instance**:
     - Deployed in the public subnet.
     - Accessible over the internet.
   - **DB instance**:
     - Deployed in the private subnet.
     - Accessible only within the VPC.

4. **Outputs**:
   - Internal and external IP addresses of the instances.
   - DNS name of the `WEB` instance.

## Project Structure

```
terraform/
├── backend.tf         # Remote backend configuration for state storage
├── main.tf            # Main configuration file
├── provider.tf        # AWS provider configuration
├── variables.tf       # Input variables
├── outputs.tf         # Output variables
└── modules/
    ├── vpc/
    │   ├── main.tf       # VPC and subnet creation
    │   ├── variables.tf  # Input variables for VPC
    ├── instances/
        ├── main.tf       # EC2 instance creation
        ├── variables.tf  # Input variables for instances
```

## Prerequisites

1. **Terraform**: Install [Terraform](https://developer.hashicorp.com/terraform/downloads).
2. **AWS Account**: Ensure you have an AWS account with the necessary permissions to create resources.
3. **S3 Bucket and DynamoDB Table**:
   - Configure S3 for backend state storage in `backend.tf`.
   - Create a DynamoDB table for state locking.

## Usage

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd terraform/
   ```

2. **Initialize Terraform**:

   ```bash
   terraform init
   ```

3. **Review the plan**:

   ```bash
   terraform plan
   ```

4. **Apply the configuration**:

   ```bash
   terraform apply
   ```

5. **Verify Outputs**:
   After successful deployment, the following outputs will be displayed:
   - Public IP of the WEB instance.
   - Private IP of the DB instance.
   - DNS name of the WEB instance.

## Customization

- Update `variables.tf` to match your specific requirements:
  - AWS region.
  - VPC CIDR block.
  - AMI ID for EC2 instances.
- Modify `backend.tf` for your S3 bucket and DynamoDB table.

## Cleanup

To destroy the created infrastructure, run:

```bash
terraform destroy
```

## Notes

- Ensure you have valid AWS credentials configured in your environment (`~/.aws/credentials` or environment variables).
- Replace placeholder values (e.g., `ami-0c55b159cbfafe1f0`) with appropriate ones for your region.

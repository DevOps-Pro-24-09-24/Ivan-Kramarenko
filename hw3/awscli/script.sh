#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables (replace placeholders with actual values)
VPC_CIDR="192.168.0.0/24"
PUBLIC_SUBNET_CIDR="192.168.0.0/25"
PRIVATE_SUBNET_CIDR="192.168.0.128/25"
AMI_ID="ami-1284a47cc718c13"
INSTANCE_TYPE="t2.micro"
KEY_NAME="MyMain"
REGION="us-east-1"

# Step 1: Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text --region $REGION)
echo "VPC created with ID: $VPC_ID"

# Step 2: Create Subnets
PUBLIC_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_SUBNET_CIDR --query 'Subnet.SubnetId' --output text --region $REGION)
echo "Public Subnet created with ID: $PUBLIC_SUBNET_ID"

PRIVATE_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIVATE_SUBNET_CIDR --query 'Subnet.SubnetId' --output text --region $REGION)
echo "Private Subnet created with ID: $PRIVATE_SUBNET_ID"

# Step 3: Create Security Groups
SG_FRONT=$(aws ec2 create-security-group --group-name sg-FRONT --description "Frontend SG" --vpc-id $VPC_ID --query 'GroupId' --output text --region $REGION)
aws ec2 authorize-security-group-ingress --group-id $SG_FRONT --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-egress --group-id $SG_FRONT --protocol -1 --cidr 0.0.0.0/0 --region $REGION
echo "Security Group FRONT created with ID: $SG_FRONT"

SG_BACK=$(aws ec2 create-security-group --group-name sg-BACK --description "Backend SG" --vpc-id $VPC_ID --query 'GroupId' --output text --region $REGION)
aws ec2 authorize-security-group-ingress --group-id $SG_BACK --protocol tcp --port 3306 --source-group $SG_FRONT --region $REGION
aws ec2 authorize-security-group-egress --group-id $SG_BACK --protocol -1 --cidr 0.0.0.0/0 --region $REGION
echo "Security Group BACK created with ID: $SG_BACK"

# Step 4: Launch EC2 Instances
WEB_INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SG_FRONT --subnet-id $PUBLIC_SUBNET_ID --query 'Instances[0].InstanceId' --output text --region $REGION)
echo "WEB Instance launched with ID: $WEB_INSTANCE_ID"

DB_INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SG_BACK --subnet-id $PRIVATE_SUBNET_ID --query 'Instances[0].InstanceId' --output text --region $REGION)
echo "DB Instance launched with ID: $DB_INSTANCE_ID"

# Step 5: Outputs
echo "VPC ID: $VPC_ID"
echo "Public Subnet ID: $PUBLIC_SUBNET_ID"
echo "Private Subnet ID: $PRIVATE_SUBNET_ID"
echo "Security Group FRONT ID: $SG_FRONT"
echo "Security Group BACK ID: $SG_BACK"
echo "WEB Instance ID: $WEB_INSTANCE_ID"
echo "DB Instance ID: $DB_INSTANCE_ID"

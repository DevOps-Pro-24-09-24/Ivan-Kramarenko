
# AWS VPC Creation and Configuration

## Variables
At the beginning of the document, define the variables used in the commands:

- `VPC_CIDR`: CIDR block for the VPC (e.g., `192.168.0.0/24`).
- `PUBLIC_SUBNET_CIDR`: CIDR block for the public subnet.
- `PRIVATE_SUBNET_CIDR`: CIDR block for the private subnet.
- `SG_FRONT`: Security Group ID for FRONT.
- `SG_BACK`: Security Group ID for BACK.
- `WEB_INSTANCE_ID`: Instance ID for the WEB server.
- `DB_INSTANCE_ID`: Instance ID for the DB server.

---

## Step 1: Create VPC
```bash
aws ec2 create-vpc --cidr-block $VPC_CIDR
```
**Example Output:**
<details>
<summary>Output</summary>

```json
{
    "Vpc": {
        "VpcId": "vpc-123abc",
        "State": "available",
        "CidrBlock": "192.168.0.0/24",
        "IsDefault": false
    }
}
```
</details>

---

## Step 2: Create Subnets
### Public Subnet
```bash
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PUBLIC_SUBNET_CIDR
```
**Example Output:**
<details>
<summary>Output</summary>

```json
{
    "Subnet": {
        "SubnetId": "subnet-123abc",
        "State": "available",
        "VpcId": "vpc-123abc",
        "CidrBlock": "192.168.0.0/25"
    }
}
```
</details>

### Private Subnet
```bash
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $PRIVATE_SUBNET_CIDR
```
**Example Output:**
<details>
<summary>Output</summary>

```json
{
    "Subnet": {
        "SubnetId": "subnet-456def",
        "State": "available",
        "VpcId": "vpc-123abc",
        "CidrBlock": "192.168.0.128/25"
    }
}
```
</details>


## Step 3: Configure Security Groups
### SG_FRONT
```bash
aws ec2 create-security-group --group-name sg-FRONT --description "Frontend SG" --vpc-id $VPC_ID
aws ec2 authorize-security-group-ingress --group-id $SG_FRONT --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-egress --group-id $SG_FRONT --protocol -1 --cidr 0.0.0.0/0
```

### SG_BACK
```bash
aws ec2 create-security-group --group-name sg-BACK --description "Backend SG" --vpc-id $VPC_ID
aws ec2 authorize-security-group-ingress --group-id $SG_BACK --protocol tcp --port 3306 --source-group $SG_FRONT
aws ec2 authorize-security-group-egress --group-id $SG_BACK --protocol -1 --cidr 0.0.0.0/0
```

---

## Step 4: Create EC2 Instances
### WEB Instance
```bash
aws ec2 run-instances --image-id ami-1284a47cc718c13 --count 1 --instance-type t2.micro --key-name MyMain --security-group-ids $SG_FRONT --subnet-id $PUBLIC_SUBNET_ID
```

### DB Instance
```bash
aws ec2 run-instances --image-id ami-1284a47cc718c13 --count 1 --instance-type t2.micro --key-name MyMain --security-group-ids $SG_BACK --subnet-id $PRIVATE_SUBNET_ID
```

---

## Step 5: Configure SSH Jump Host
```bash
ssh -J ec2-user@$WEB_PUBLIC_IP ec2-user@$DB_PRIVATE_IP
```

---

## Step 6: User Data
### WEB Instance
```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
```

### DB Instance
```bash
#!/bin/bash
yum update -y
yum install -y mysql-server
systemctl start mysqld
systemctl enable mysqld
```

---

## Additional Verification Commands
### Describe VPC
```bash
aws ec2 describe-vpcs --vpc-ids $VPC_ID
```

### Describe Subnets
```bash
aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID
```

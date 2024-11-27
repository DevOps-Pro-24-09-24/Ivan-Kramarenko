variable "region" {
  description = "AWS region to deploy the AMI."
}

variable "instance_size" {
  description = "Instance type for building the AMI."
}

variable "base_ami" {
  description = "Base AMI to use for building the database image."
}

source "amazon-ebs" "db" {
  region           = var.region
  source_ami       = var.base_ami
  instance_type    = var.instance_size
  ami_name         = "db-ami"
  ssh_username     = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.db"]

  provisioner "shell" {
    inline = [
      "echo 'Updating packages...' && sudo apt-get update",
      "echo 'Installing MySQL Server...' && sudo apt-get install -y mysql-server",
      "echo 'Creating database...' && sudo mysql -e \"CREATE DATABASE app_db;\" || echo 'Failed to create database'",
      "echo 'Creating user...' && sudo mysql -e \"CREATE USER 'app_user'@'%' IDENTIFIED BY 'password';\" || echo 'Failed to create user'",
      "echo 'Granting privileges...' && sudo mysql -e \"GRANT ALL PRIVILEGES ON app_db.* TO 'app_user'@'%';\" || echo 'Failed to grant privileges'"
    ]
  }
}

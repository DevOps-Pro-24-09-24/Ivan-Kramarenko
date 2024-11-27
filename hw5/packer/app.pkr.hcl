variable "region" {
  description = "AWS region to deploy the AMI."
}

variable "instance_size" {
  description = "Instance type for building the AMI."
}

variable "base_ami" {
  description = "Base AMI to use for building the app image."
}

source "amazon-ebs" "app" {
  region           = var.region
  source_ami       = var.base_ami
  instance_type    = var.instance_size
  ami_name         = "app-ami"
  ssh_username     = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.app"]

  provisioner "shell" {
    inline = [
      "echo 'Updating packages...' && sudo apt-get update",
      "echo 'Installing Python3 and pip...' && sudo apt-get install -y python3-pip",
      "echo 'Installing Python dependencies...' && pip3 install -r /homework5/packer/examples/flask-alb-app/requirements.txt"
    ]
  }
}

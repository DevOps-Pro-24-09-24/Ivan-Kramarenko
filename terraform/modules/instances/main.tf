
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_id
  tags = {
    Name = "Web_Instance"
  }

  security_groups = [var.sg_front_id]
}

resource "aws_instance" "db" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_id
  tags = {
    Name = "DB_Instance"
  }

  security_groups = [var.sg_back_id]
}

output "web_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "db_instance_private_ip" {
  value = aws_instance.db.private_ip
}

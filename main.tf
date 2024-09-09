
provider "aws" {
  region = "ap-southeast-1"
}

# Security group definition
resource "aws_security_group" "five" {
  name        = "elb-sg"
  description = "Security group for web and app servers"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web server instance 1
resource "aws_instance" "one" {
  ami                    = "ami-0182f373e66f89c85"
  instance_type          = "t2.micro"
  key_name               = "Prasadpair"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "ap-southeast-1a"
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "hai all this is my app created by terraform infrastructurte by prasad server-1" > /var/www/html/index.html
    EOF

  tags = {
    Name = "web-server-1"
  }
}

# Web server instance 2
resource "aws_instance" "two" {
  ami                    = "ami-0182f373e66f89c85"
  instance_type          = "t2.micro"
  key_name               = "Prasadpair"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "ap-southeast-1b"
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "hai all this is my website created by terraform infrastructurte by prasad server-2" > /var/www/html/index.html
    EOF

  tags = {
    Name = "web-server-2"
  }
}

# Application server 1
resource "aws_instance" "three" {
  ami                    = "ami-0182f373e66f89c85"
  instance_type          = "t2.micro"
  key_name               = "Prasadpair"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "ap-southeast-1a"

  tags = {
    Name = "app-server-1"
  }
}

# Application server 2
resource "aws_instance" "four" {
  ami                    = "ami-0182f373e66f89c85"
  instance_type          = "t2.micro"
  key_name               = "Prasadpair"
  vpc_security_group_ids = [aws_security_group.five.id]
  availability_zone      = "ap-southeast-1b"

  tags = {
    Name = "app-server-2"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "six" {
  bucket = "terraserverbucket9988oo9988"
}

# IAM Users (looped over user names)
resource "aws_iam_user" "seven" {
  for_each = var.user_names
  name     = each.value
}

# Input variable for IAM user names
variable "user_names" {
  description = "List of IAM users"
  type        = set(string)
  default     = ["user1", "user2", "user3", "user4"]
}

# EBS Volume
resource "aws_ebs_volume" "eight" {
  availability_zone = "ap-southeast-1a"
  size              = 40

  tags = {
    Name = "ebs-001"
  }
}

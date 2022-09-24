provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "my-tf-bucket-23127894263"
  acl = "private"
}

resource"aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name = "prod_web"
  description = "allow HTTP and HTTPS inbound"
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
  "Terraform" : "true"
  }
}

resource "aws_instance" "prod_web" {
  ami = "ami-075d1bca6bb7d32bc"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ] 

  tags = {
  "Terraform" : "true"
  }
}
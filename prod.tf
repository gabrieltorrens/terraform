variable "whitelist" {
  type = list(string)
}
variable "web_image_id" {
  type = string
}
variable "web_instance_type" {
  type = string
}
variable "web_desired_capacity" {
  type = string
}
variable "web_max_size" {
  type = string
}
variable "web_min_size" {
  type = string
}


provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "my-tf-bucket-23127894263"
  acl = "private"

  tags = {
    "Terraform" : "true"
  }
}

resource"aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_security_group" "prod_web" {
  name = "prod_web"
  description = "allow HTTP and HTTPS inbound"
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = var.whitelist
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = var.whitelist
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.whitelist
  }

  tags = {
  "Terraform" : "true"
  }
}

module "web_app" {
  source = "./modules/web_app"

  web_image_id = var.web_image_id #defined in tfvars
  web_instance_type = var.web_instance_type
  web_desired_capacity = var.web_desired_capacity
  web_max_size = var.web_max_size
  web_min_size = var.web_min_size
  subnets = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups = [aws_security_group.prod_web.id]
  web_app = "prod"
}

/*
resource "aws_instance" "prod_web" {
  count = 2

  ami = "ami-075d1bca6bb7d32bc"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ] 

  tags = {
  "Terraform" : "true"
  }
}


resource "aws_eip_association" "prod_web" {
  instance_id = aws_instance.prod_web.0.id #references one instance
  allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {
  tags = {
    "Terraform" : "true"
  }
}
*/
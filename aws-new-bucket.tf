provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "my-tf-bucket-23127894263"
  acl = "private"
}

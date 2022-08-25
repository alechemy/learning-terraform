provider "aws" {
  profile = "default"
  region  = "us-west-1"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-1661445723924"
}

resource "aws_s3_bucket_acl" "prod_tf_course_bucket_acl" {
  bucket = aws_s3_bucket.prod_tf_course.id
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    # any IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # all open
    from_port = 0
    to_port   = 0
    # all protocols out
    protocol = "-1"
    # any IP
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }
}

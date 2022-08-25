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

resource "aws_instance" "prod_web" {
  count = 2

  ami           = "ami-0bf2de022ba73d0be"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

# De-couple creation of IP and its assignment
resource "aws_eip_association" "prod_web" {
  instance_id   = aws_instance.prod_web[0].id
  allocation_id = aws_eip.prod_web.id
}

# static IP
resource "aws_eip" "prod_web" {
  tags = {
    "Terraform" : "true"
  }
}

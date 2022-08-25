provider "aws" {
  profile = "default"
  region  = "us-west-1"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "tf-course-1661445723924"
}

resource "aws_s3_bucket_acl" "tf_course_bucket_acl" {
  bucket = aws_s3_bucket.tf_course.id
  acl    = "private"
}

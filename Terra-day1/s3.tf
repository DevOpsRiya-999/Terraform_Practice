resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-tf-test-bucket-by-riya"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
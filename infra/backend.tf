terraform {
  backend "s3" {
    region = "eu-north-1"
    bucket = "aeirola-sukunimitin-terraform-state"
    key    = "terraform.tfstate"
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "aeirola-sukunimitin-terraform-state"
}

resource "aws_s3_bucket_acl" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration { status = "Enabled" }
}

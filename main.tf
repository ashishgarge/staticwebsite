terraform {
  required_providers {
    aws = {
      version = "= 5.33.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-state-ashish01"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "mybucketsafsdashish58567564"
  tags = {
    Name = "ashish543r3fsdf"
  }
}

resource "aws_s3_bucket_website_configuration" "s3_website" {
  bucket = "mybucketsafsdashish54"
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_block_public_access" {
  bucket                  = "mybucketsafsdashish54"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "PublicReadGetObject"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.my_bucket.arn}/*"]
  }

}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "mybucketsafsdashish54"
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_object" "website_object" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  content_type = "text/html"
  source       = "${path.module}/index.html"
  etag         = filemd5("${path.module}/index.html")
  acl          = "bucket-owner-full-control"
}

resource "aws_s3_bucket_versioning" "enable_versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }

}

#this is the output block which will display the website address after the terraform apply command is executed successfully
output "website_address" {
  description = "Static website is accessible on this address"
  value       = aws_s3_bucket_website_configuration.s3_website.website_endpoint
}

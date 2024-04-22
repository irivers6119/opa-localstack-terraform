provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_check         = true
  skip_requesting_account_id  = true

  endpoints = {
    ec2 = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-test-bucket"  # replace with your bucket name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        # coming from the module kms definition in the kms.tf
        kms_master_key_id = module.kms.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }



  tags = {
    Name        = "My test bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket" "example" {
  bucket = "my-tf-example-bucket"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.example.id
  acl    = "public-read"
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


  resource "aws_instance" "web" {
    count         = 3
    instance_type = "t2.micro"
    ami           = "ami-09b4b74c"
    
    vpc_security_group_ids = [aws_security_group.ssh.id]
  }




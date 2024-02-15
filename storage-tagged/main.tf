terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

variable "bucket_name" {
  type    = string
  default = "by-terraform-s3-goof-bucket"
}

variable "s3_acl" {
  type    = string
  default = "public-read-write"
}

resource "aws_s3_bucket" "by-s3-bucket" {
  bucket = var.bucket_name
  tags = {
    owner = "devteam1"
    classification = "internal"
  }
}

resource "aws_s3_bucket_acl" "by-s3-bucket-acl" {
  bucket = aws_s3_bucket.by-s3-bucket.id
  acl    = var.s3_acl
}

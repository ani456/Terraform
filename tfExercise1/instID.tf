# data "aws_ami" "amiID" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Amazon
# }

# output "instance_id" {
#   description = "AMI id of ubuntu instance"
#   value       = data.aws_ami.amiID.id
# }


resource "aws_s3_bucket" "poneglyph-bucket" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.tags, {
    Name    = var.bucket_name
    Purpose = "terraform-state"
  })

}
# Versioning - critical for state recovery if something corrupts it
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.poneglyph-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt state at rest - it can contain secrets
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.poneglyph-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block ALL public access - state files often contain sensitive data
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.poneglyph-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



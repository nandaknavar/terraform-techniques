resource "aws_s3_bucket" "data" {
  bucket = "data-s3"

  tags = {
    "Name" = "data-s3"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "policy" {
  bucket = aws_s3_bucket.data.id

  rule {
    id     = "expire-older-versions"
    status = var.lifecycle_rules.status

    noncurrent_version_expiration {
      noncurrent_days = var.lifecycle_rules.noncurrent_expire_days
    }
  }

  rule {
    id     = "archive-older-data"
    status = var.lifecycle_rules.status

    filter {
      object_size_greater_than = var.lifecycle_rules.minimum_object_size
    }

    expiration {
      days = var.lifecycle_rules.expiration_days
    }

    dynamic "transition" {
      for_each = var.lifecycle_rules.transition[*]

      content {
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }
  }
}
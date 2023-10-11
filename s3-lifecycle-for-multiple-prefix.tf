resource "aws_s3_bucket" "archive" {
  bucket = "archive-s3"

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_prefix_rules

    content {
      id      = lifecycle_rule.key
      enabled = lifecycle_rule.value.enabled
      prefix  = "${lifecycle_rule.key}/"

      dynamic "transition" {
        for_each = lifecycle_rule.value.transition[*]

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }

  tags = {
    "Name" = "archive-s3"
  }
}
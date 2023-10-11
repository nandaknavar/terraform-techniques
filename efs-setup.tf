resource "aws_efs_file_system" "share" {
  encrypted = true

  lifecycle_policy {
    transition_to_ia = var.efs_ia_transition
  }

  tags = {
    "Name" = "cmn-efs"
  }
}

resource "aws_efs_mount_target" "share" {
  for_each = toset(data.aws_subnets.private.ids)

  file_system_id  = aws_efs_file_system.share.id
  subnet_id       = each.key
  security_groups = [aws_security_group.main.id]
}

resource "aws_efs_access_point" "share" {
  file_system_id = aws_efs_file_system.share.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/sample-share"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = 755
    }
  }

  tags = {
    "Name" = "efs-ap"
  }
}

resource "aws_efs_file_system_policy" "deny_unsecure" {
  file_system_id = aws_efs_file_system.share.id
  policy         = data.aws_iam_policy_document.deny_unsecure.json
}

data "aws_iam_policy_document" "deny_unsecure" {
  version = "2012-10-17"

  statement {
    effect  = "Deny"
    actions = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
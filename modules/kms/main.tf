data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_account_id        = data.aws_caller_identity.current.account_id
  aws_region            = data.aws_region.current.name
  aws_account_principal = "arn:aws:iam::${local.aws_account_id}:root"
}

resource "aws_kms_key" "ec2" {
  description             = "EC2 instance CMK"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "ec2" {
  name          = "alias/ec2"
  target_key_id = aws_kms_key.ec2.key_id
}

resource "aws_kms_key_policy" "ec2" {
  key_id = aws_kms_key.ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "EC2Project"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "${local.aws_account_principal}"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = [
            "${var.rolea_arn}", "${var.roleb_arn}"
          ]
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
        ]
        Resource = "*"
      }
    ]
  })
}

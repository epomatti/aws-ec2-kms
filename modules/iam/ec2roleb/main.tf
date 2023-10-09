resource "aws_iam_instance_profile" "default" {
  name = "EC2RoleA"
  role = aws_iam_role.default.id
}

resource "aws_iam_role" "default" {
  name = "EC2RoleA"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "deny_kms" {
  name = "RoleBDenyKMS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0"
        Effect = "Deny"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:DescribeKey"
        ]
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "deny_kms" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.deny_kms.arn
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

output "instance_profile_id" {
  value = aws_iam_instance_profile.default.id
}

output "role_arn" {
  value = aws_iam_role.default.arn
}

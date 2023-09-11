output "role_name" {
    value = aws_iam_role.mylambda_role.name
}

output "role_arn" {
    value = aws_iam_role.mylambda_role.arn
}

output "policy_arn" {
    value = aws_iam_policy.my_iam_policy_for_lambda.arn
}

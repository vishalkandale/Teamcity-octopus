resource "aws_iam_role" "mylambda_role" {
    name = "my_lambda_role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "my_iam_policy_for_lambda" {
    name = "my_lambda_policy"
    path = "/"
    description = "AWS IAM policy for managing aws lambda role"

#output will see on the logs as well as return massage
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": [                      
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:logs:*.*.*"
        }
    ]
}
EOF
}


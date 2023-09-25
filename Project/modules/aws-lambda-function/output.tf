output "lambda_arn" {
    value = aws_lambda_function.mylambda_function.arn
}

output "function_name" {
    value = aws_lambda_function.mylambda_function.function_name
}

output "timeout" {
    value = aws_lambda_function.mylambda_function.timeout
}

output "memory_size" {
    value = aws_lambda_function.mylambda_function.memory_size
}

output "bucket_name" {
    value = aws_s3_bucket.zip-file-bucket.bucket
}
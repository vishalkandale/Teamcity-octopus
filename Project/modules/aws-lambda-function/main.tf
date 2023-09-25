data "archive_file" "zip_the_code_file" {
    type = "zip"
    source_dir = "${path.module}/../../python"
    output_path = "${path.module}/../../python/code.zip"
}

resource "aws_s3_bucket" "zip-file-bucket" {
    bucket = var.bucket_name
}

resource "aws_s3_object" "file_upload" {
    bucket = aws_s3_bucket.zip-file-bucket.id
    key    = "code.zip"
    source = data.archive_file.zip_the_code_file.output_path # its mean it depended on zip
}

resource "aws_lambda_function" "mylambda_function" {
    function_name = var.function_name
    s3_bucket = aws_s3_bucket.zip-file-bucket.id
    s3_key = aws_s3_object.file_upload.key
    role = var.role_arn
    handler = "code.lambda_handler"  #(<file_name>.<fucntion_name_of_python_code>)
    runtime = "python3.10"
    timeout = 2
}


resource "aws_cloudwatch_log_group" "my_logs" {
    name = "/aws/lambda/my_lambda_function"
}

resource "aws_cloudwatch_event_rule" "event-rule" {
    name        = var.event_rule
    description = "Trigger in every 5 min"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda-func" {
    rule      = aws_cloudwatch_event_rule.event-rule.name
    target_id = "lambda"
    arn = var.my_lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name = var.my_function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.event-rule.arn
}
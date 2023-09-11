locals {
    project-name = "lambda-project"
    metrics-calculator-memory-name = "Memory"
    metrics-calculator-namespace = "${local.project-name}/calculator"
}


resource "aws_cloudwatch_log_metric_filter" "calculator-memory-filter" {
    name           = "${local.project-name}-calculator-memory"
    log_group_name = "/aws/lambda/${var.my_function_name}"
    pattern = "[report_name=\"REPORT\", request_id_name=\"RequestId:\", request_id_value, duration_name=\"Duration:\", duration_value, duration_unit=\"ms\", billed_duration_name_1=\"Billed\", bill_duration_name_2=\"Duration:\", billed_duration_value, billed_duration_unit=\"ms\", memory_size_name_1=\"Memory\", memory_size_name_2=\"Size:\", memory_size_value, memory_size_unit=\"MB\", max_memory_used_name_1=\"Max\", max_memory_used_name_2=\"Memory\", max_memory_used_name_3=\"Used:\", max_memory_used_value, max_memory_used_unit=\"MB\"]"

    metric_transformation {
        name      = "${local.metrics-calculator-memory-name}"
        namespace = "${local.metrics-calculator-namespace}"
        value     = "$max_memory_used_value"
    }
}

resource "aws_sns_topic" "alarms" {
    name = "${local.project-name}-alarms"
}

resource "aws_cloudwatch_metric_alarm" "calculator-time" {
    alarm_name          = "${local.project-name}-calculator-execution-time"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "1"
    metric_name         = "Duration"
    namespace           = "AWS/Lambda"
    period              = "60"
    statistic           = "Maximum"
    threshold           = "${var.lambda_timeout * 1000 * 0.75}"  #calculates 75% of the timeout value of lambda function and assign it threshhold
    alarm_description   = "Calculator Execution Time"
    treat_missing_data  = "ignore"

    insufficient_data_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]

    alarm_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]

    ok_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]

    dimensions = {
        FunctionName = "${var.my_function_name}"
        Resource     = "${var.my_function_name}"
    }
}

resource "aws_cloudwatch_metric_alarm" "calculator-memory" {
    depends_on = [ aws_cloudwatch_log_metric_filter.calculator-memory-filter ]

    alarm_name          = "${local.project-name}-calculator-memory"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "1"
    metric_name         = "${local.metrics-calculator-memory-name}"
    namespace           = "${local.metrics-calculator-namespace}"
    period              = "60"
    statistic           = "Maximum"
    threshold           = "${var.lambda_memory_size * 0.8}"
    alarm_description   = "Calculator Max Memory Consumption"
    treat_missing_data  = "notBreaching"

    insufficient_data_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]

    alarm_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]

    ok_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]
    }

resource "aws_cloudwatch_metric_alarm" "calculator-errors" {
    alarm_name          = "${local.project-name}-calculator-errors"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = "1"
    metric_name         = "Errors"
    namespace           = "AWS/Lambda"
    period              = "60"
    statistic           = "Maximum"
    threshold           = 0
    alarm_description   = "Calculator Execution Errors"
    treat_missing_data  = "ignore"

    insufficient_data_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]

    alarm_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]

    ok_actions = [
        "${aws_sns_topic.alarms.arn}",
    ]

    dimensions = {
        FunctionName = "${var.my_function_name}"
        Resource     = "${var.my_function_name}"
    }
}
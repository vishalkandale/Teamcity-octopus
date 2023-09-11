locals {
  max-time-color   = "#1f77b4"
  avg-time-color   = "#9467bd"
  memory-color     = "#ff7f0e"
  error-color      = "#d62728"
  invocation-color = "#2ca02c"
}

resource "aws_cloudwatch_dashboard" "my_dashboard" {
    dashboard_name = var.dashboard_name

    dashboard_body = jsonencode({
        widgets = [
            {
                type = "metric",
                x = 0,
                y = 0,
                width = 8,
                height = 6,
                properties = {
                    markdown = "## Lambda Dashboard"
                    metrics = [
                    [
                        "AWS/Lambda", "Invocations",
                        "FunctionName", "${var.my_function_name}",
                        "Resource", "${var.my_function_name}",
                        {
                            stat = "Sum",
                            color = "${local.invocation-color}",
                            period = 5

                        }
                    ]
                    ],
                    view = "timeSeries",
                    stacked = false,
                    liveData = true,
                    region = var.region,
                    title = "Invocations"
                }
            },
            {
                type = "metric",
                x = 8,
                y = 0,
                width = 8,
                height = 6,
                properties = {
                    markdown = "## Lambda Dashboard"
                    metrics = [
                    [
                        "AWS/Lambda", "Errors",
                        "FunctionName", "${var.my_function_name}",
                        "Resource", "${var.my_function_name}",
                        {   
                            stat = "Sum",
                            color = "${local.error-color}",
                            period = 5
                        }
                    ]
                    ],
                    view = "timeSeries",
                    stacked = false,
                    liveData = true,
                    region = var.region,
                    title = "Execution Errors"
                    annotations = {
                    horizontal = [{
                        color = "${local.error-color}",
                        label = "Alarm Threshold",
                        value = "${var.lambda_metric_error_threshold}"
                    }
                    ]
                }
                }
            },
            {
                type = "metric",
                x = 16,
                y = 0,
                width = 8,
                height = 6,
                properties = {
                    markdown = "## Lambda Dashboard"
                    metrics = [
                    [
                        "AWS/Lambda", "Duration",
                        "FunctionName", "${var.my_function_name}",
                        "Resource", "${var.my_function_name}",
                        {
                            stat = "Maximum",
                            yAxis = "left",
                            color = "${local.max-time-color}",
                            label = "Maximum Execution Time",
                            period = 5
                        }
                    ],
                    [
                        "AWS/Lambda", "Duration",
                        "FunctionName", "${var.my_function_name}",
                        "Resource", "${var.my_function_name}",
                        {
                            stat = "Average",
                            yAxis = "left",
                            color = "${local.avg-time-color}",
                            label = "Average Execution Time",
                            period = 5                
                        }
                    ]
                    ],
                    view = "timeSeries",
                    stacked = false,
                    liveData = true,
                    region = var.region,
                    title = "Duration"
                }
            },
            {
                type = "metric",
                x = 0,
                y = 8,
                width = 8,
                height = 6,
                properties = {
                    markdown = "## Lambda Dashboard"
                    metrics = [
                    [
                        "${var.metric_namespace}", "${var.memory_name}",
                        {
                            stat = "Maximum",
                            color = "${local.memory-color}",
                            label = "Max Memory Used",
                            period = 5
                        }
                    ]
                    ],
                    view = "timeSeries",
                    stacked = false,
                    liveData = true,
                    region = var.region,
                    yAxis = {
                        left = {
                            min = 0,
                            max = "${var.lambda_memory_size}",
                            showUnits = false,
                            label = "MB"
                        }
                        },
                    title = "Memory Consumption"
                    period = 300,
                    annotations = {
                        horizontal = [{
                            color = "${local.memory-color}",
                            label = "Alarm Threshold",
                            value = "${var.lambda_metric_memory_threshold}"
                        }
                    ]
                    }
                }
            }
        ]
    })
}
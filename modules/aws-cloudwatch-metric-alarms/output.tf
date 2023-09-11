output "metric_memory_threshold" {
    value = aws_cloudwatch_metric_alarm.calculator-memory.threshold
}

output "metric_error_threshold" {
    value = aws_cloudwatch_metric_alarm.calculator-errors.threshold
}

output "metrics-calculator-namespace" {
    value = local.metrics-calculator-namespace
}

output "metrics-calculator-memory-name" {
    value = local.metrics-calculator-memory-name
}
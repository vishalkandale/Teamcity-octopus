locals {
    role_name = module.iam_role.role_name
    policy_arn = module.iam_role.policy_arn
    role_arn = module.iam_role.role_arn
    lambda_arn = module.lambda_function.lambda_arn
    fun_name = module.lambda_function.function_name
    timeout = module.lambda_function.timeout
    memory_size = module.lambda_function.memory_size
    metric_memory_threshold = module.cloudwatch_metric_alarm.metric_memory_threshold
    metric_error_threshold = module.cloudwatch_metric_alarm.metric_error_threshold
    memory_name = module.cloudwatch_metric_alarm.metrics-calculator-memory-name
    namespace_name = module.cloudwatch_metric_alarm.metrics-calculator-namespace
}

module "iam_role" {
    source = "./modules/aws-iam"
    iam_role_name = var.iam_rolename
    iam_policy_name = var.iam_policyname
}

resource "aws_iam_role_policy_attachment" "mylambda_policy_attach" {
    role       = local.role_name
    policy_arn = local.policy_arn
}


module "lambda_function"{
    source = "./modules/aws-lambda-function"
    bucket_name = var.bucket-name
    function_name = var.function_name
    role_arn = local.role_arn
    depends_on = [ aws_iam_role_policy_attachment.mylambda_policy_attach ]
}

module "cloudwatch_event_rule" {
    source = "./modules/aws-cloudwatch-eventlogs"
    event_rule = var.event_rule_name
    my_lambda_arn = local.lambda_arn
    my_function_name = local.fun_name
}

module "cloudwatch_dashboard" {
    source = "./modules/aws-cloudwatch-dashboard"
    dashboard_name = var.dashboard_name
    region = var.region
    my_function_name = local.fun_name
    lambda_memory_size = local.memory_size
    lambda_metric_error_threshold = local.metric_error_threshold
    lambda_metric_memory_threshold = local.metric_memory_threshold
    memory_name = local.memory_name
    metric_namespace = local.namespace_name
}

module "cloudwatch_metric_alarm" {
    source = "./modules/aws-cloudwatch-metric-alarms"
    my_function_name = local.fun_name
    lambda_timeout = local.timeout
    lambda_memory_size = local.memory_size
}
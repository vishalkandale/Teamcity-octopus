variable "region" {
    default = "ap-south-1"
}

variable "iam_rolename" {
    type = string
    default = "default"
}

variable "iam_policyname" {
    type = string
    default = "default"
}

variable "dashboard_name" {
    type = string
    default = "default"
}

variable "event_rule_name" {
    type = string
    default = "default"
}

variable "function_name" {
    type = string
    default = "default"
}

variable "bucket-name" {
    default = "default"
}
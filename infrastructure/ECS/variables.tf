variable "project" {
  description = "The project name"
  type        = string
}

variable "security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

variable "max_instances" {
  description = "The max number of allowed instances"
  type        = string
  default     = 1
}

variable "min_instances" {
  description = "The min number of allowed instances"
  type        = string
  default     = 1
}

variable "desired_instances" {
  description = "The desired number of instances"
  type        = string
  default     = 1
}

variable "key_name" {
  description = "The deployment key name"
  type        = string
}

variable "lb_target_group_arn" {
  description = "The target group arn of the load balancer"
  type        = string
}

variable "log_retention" {
  description = "Cloudwatch log retention in days"
  type        = number
  default     = 14
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "desired_service_tasks" {
  description = "Desired number of tasks running on service"
  type        = number
  default     = 1
}

variable "deployment_maximum_percent" {
  description = "Maximum health percentage on deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum health percentage on deployment"
  type        = number
  default     = 100
}
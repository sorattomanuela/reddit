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

variable "vpc_id" {
  description = "The VPC identifier"
  type        = string
}

variable "certificate_arn" {
  description = "Certificate ARN"
  type        = string
}

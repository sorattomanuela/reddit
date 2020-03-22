variable "project" {
  description = "The project name"
  type        = string
}

variable "cdn_domain" {
  description = "CDN custom domain"
  type        = list(string)
}

variable "certificate_arn" {
  description = "Certificate ARN"
  type        = string
}
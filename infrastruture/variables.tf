variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "name" {
  type    = string
  default = "viren"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "CIDR cho SSH"
  default     = "0.0.0.0/0"
}

variable "domain_name" {
  type        = string
  description = "Root domain cho Route53/ACM (vd: virenfashion.com)"
}

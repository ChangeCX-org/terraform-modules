variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "AZ where Outpost is anchored."
  type        = string
  default     = null
}
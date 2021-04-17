variable "provider" {
  description = "AWS Account"
  type        = string
  default     = null
}

variable "region" {
  description = "region."
  type        = string
  default     = null
}

variable "name" {
  description = "name."
  type        = string
  default     = null
}

variable "env" {
  description = "environment."
  type        = string
  default     = null
}

variable "namespace" {
  description = "namespace."
  type        = string
  default     = null
}

variable "cidr" {
  description = "cidr block for VPC."
  type        = string
  default     = null
}

variable "availability_zones" {
  description = "AZs where Outpost is anchored."
  type        = list(string)
  default     = null
}

variable "private_subnets" {
  description = "private subnets ip ranges."
  type        = list(string)
  default     = null
}

variable "public_subnets" {
  description = "public subnets ip ranges."
  type        = list(string)
  default     = null
}

variable "database_subnets" {
  description = "database subnets ip ranges."
  type        = list(string)
  default     = null
}

variable "elasticache_subnets" {
  description = "elasticache subnets ip ranges."
  type        = list(string)
  default     = null
}

variable "redshift_subnets" {
  description = "redshift subnets ip ranges."
  type        = list(string)
  default     = null
}

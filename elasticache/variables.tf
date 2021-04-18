variable "name" {
  type        = string
  description = "The replication group identifier. This parameter is stored as a lowercase string."
}

variable "number_cache_clusters" {
  type        = string
  description = "The number of cache clusters (primary and replicas) this replication group will have."
}

variable "node_type" {
  type        = string
  description = "The compute and memory capacity of the nodes in the node group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the cache subnet group."
}

variable "vpc_id" {
  type        = string
  description = "VPC Id to associate with Redis ElastiCache."
}

variable "source_cidr_blocks" {
  type        = list(string)
  description = "List of source CIDR blocks."
}

variable "engine_version" {
  default     = "5.0.6"
  type        = string
  description = "The version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "port" {
  default     = 6379
  type        = number
  description = "The port number on which each of the cache nodes will accept connections."
}

variable "maintenance_window" {
  default     = ""
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed."
}

variable "snapshot_window" {
  default     = ""
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
}

variable "snapshot_retention_limit" {
  default     = 30
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
}

variable "automatic_failover_enabled" {
  default     = true
  type        = bool
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails."
}

variable "at_rest_encryption_enabled" {
  default     = true
  type        = bool
  description = "Whether to enable encryption at rest."
}

variable "transit_encryption_enabled" {
  default     = true
  type        = bool
  description = "Whether to enable encryption in transit."
}

variable "apply_immediately" {
  default     = false
  type        = bool
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window."
}

variable "family" {
  default     = "redis5.0"
  type        = string
  description = "The family of the ElastiCache parameter group."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

variable "environment" {
  default     = "prod"
  type        = string
  description = "Environment"
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region"
}

variable "vpc_dns_zone_id" {
  default     = "Z019847324VXSJ595M5RD"
  type        = string
  description = "Hosted Zone ID."
}

variable "vpc_dns_zone_name" {
  default     = "finverselabs.com."
  type        = string
  description = "Hosted Zone Name."
}

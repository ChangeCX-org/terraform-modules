output "alb_id" {
  value       = join("", aws_alb.alb.*.id)
  description = "The ARN of the load balancer (matches arn)."
}

output "alb_arn" {
  value       = join("", aws_alb.alb.*.arn)
  description = "The ARN of the load balancer (matches id)."
}

output "alb_arn_suffix" {
  value       = join("", aws_alb.alb.*.arn_suffix)
  description = "The ARN suffix for use with CloudWatch Metrics."
}

output "alb_dns_name" {
  value       = join("", aws_alb.alb.*.dns_name)
  description = "The DNS name of the load balancer."
}

output "alb_zone_id" {
  value       = join("", aws_alb.alb.*.zone_id)
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "https_alb_listener_id" {
  value       = join("", aws_alb_listener.alb.*.id)
  description = "The ARN of the HTTPS listener (matches arn)"
}

output "https_alb_listener_arn" {
  value       = join("", aws_alb_listener.alb.*.arn)
  description = "The ARN of the HTTPS listener (matches id)"
}

output "alb_target_group_id" {
  value       = join("", aws_alb_target_group.alb.*.id)
  description = "The ARN of the Target Group (matches arn)"
}

output "alb_target_group_arn" {
  value       = join("", aws_alb_target_group.alb.*.arn)
  description = "The ARN of the Target Group (matches id)"
}

output "alb_target_group_arn_suffix" {
  value       = join("", aws_alb_target_group.alb.*.arn_suffix)
  description = "The ARN suffix for use with CloudWatch Metrics."
}

output "alb_target_group_name" {
  value       = join("", aws_alb_target_group.alb.*.name)
  description = "The name of the Target Group."
}

output "alb_target_group_port" {
  value       = join("", aws_alb_target_group.alb.*.port)
  description = "The port of the Target Group."
}

output "security_group_id" {
  value       = join("", aws_security_group.default.*.id)
  description = "The ID of the alb security group."
}

output "security_group_arn" {
  value       = join("", aws_security_group.default.*.arn)
  description = "The ARN of the alb security group."
}

output "security_group_vpc_id" {
  value       = join("", aws_security_group.default.*.vpc_id)
  description = "The VPC ID of the alb security group."
}

output "security_group_owner_id" {
  value       = join("", aws_security_group.default.*.owner_id)
  description = "The owner ID of the alb security group."
}

output "security_group_name" {
  value       = join("", aws_security_group.default.*.name)
  description = "The name of the alb security group."
}

output "security_group_description" {
  value       = join("", aws_security_group.default.*.description)
  description = "The description of the alb security group."
}

output "security_group_ingress" {
  value       = flatten(aws_security_group.default.*.ingress)
  description = "The ingress rules of the alb security group."
}

output "security_group_egress" {
  value       = flatten(aws_security_group.default.*.egress)
  description = "The egress rules of the alb security group."
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_region" "current" {}

data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier = "Public"
  }
}

data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier = "Private"
  }
}

data "aws_subnet" "public_subnets" {
  for_each = data.aws_subnet_ids.public_subnet_ids.ids
  id       = each.value
}

data "aws_subnet" "private_subnets" {
  for_each = data.aws_subnet_ids.private_subnet_ids.ids
  id       = each.value
}

data "aws_route53_zone" "zone" {
  name = "${var.domain_name}."
}

module "ecs_fargate" {
  source           = "../../"
  name             = var.container_name
  container_name   = var.container_name
  container_port   = var.container_port
  cluster          = aws_ecs_cluster.user_backend.arn
  subnets          = [for s in data.aws_subnet.public_subnets : s.id]
  target_group_arn = module.alb.alb_target_group_arn
  vpc_id           = data.aws_vpc.vpc.id

  container_definitions = jsonencode([
    {
      cpu : 0,
      name: local.container_name,
      image : var.image,
      essential: true,
      portMappings: [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ],
      logConfiguration: {
         "logDriver": "awslogs",
         "options": {
            "awslogs-group" : "/aws/ecs/${local.container_name}",
            "awslogs-region": data.aws_region.current.name,
            "awslogs-stream-prefix": local.container_name
          }
      },
      ulimits: [
          {
            name: "nofile",
            softLimit: 500000,
            hardLimit: 500000
          }
      ],
      environment: [
          {
            name: "env",
            value: var.env
          },
          {
            name: "service",
            value: var.name
          },
          {
            name: "region",
            value: data.aws_region.current.name
          },
      ],
    }
  ])

  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  deployment_controller_type         = "ECS"
  assign_public_ip                   = true
  health_check_grace_period_seconds  = 10
  platform_version                   = "LATEST"
  source_cidr_blocks                 = ["0.0.0.0/0"]
  cpu                                = var.cpu
  memory                             = var.memory
  requires_compatibilities           = ["FARGATE"]
  iam_path                           = "/service_role/"
  description                        = "Backend Microservice"
  enabled                            = true

  create_ecs_task_execution_role = false
  ecs_task_execution_role_arn    = aws_iam_role.user_backend.arn

  tags = {
    env = var.env
  }
}

resource "aws_iam_role" "user_backend" {
  name               = "ecs-task-execution-for-ecs-fargate-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "user_backend" {
  name   = aws_iam_role.user_backend.name
  policy = data.aws_iam_policy.ecs_task_execution.policy
}

resource "aws_iam_role_policy_attachment" "user_backend" {
  role       = aws_iam_role.user_backend.name
  policy_arn = aws_iam_policy.user_backend.arn
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

locals {
  container_name = "${var.name}-${var.env}"
  container_port = tonumber(module.alb.alb_target_group_port)
}

resource "aws_ecs_cluster" "user_backend" {
  name = local.container_name
}

module "alb" {
  source                                 = "../../../alb"
  name                                   = local.container_name
  vpc_id                                 = data.aws_vpc.vpc.id
  subnets                                = [for s in data.aws_subnet.public_subnets : s.id]
  access_logs_bucket                     = module.s3_lb_log.s3_bucket_id
  certificate_arn                        = "arn:aws:acm:us-east-1:019852877010:certificate/8612cc56-3898-44f5-b583-01ed6685846c"

  enable_https_listener                  = true
  enable_http_listener                   = true
  enable_redirect_http_to_https_listener = true

  internal                               = false
  idle_timeout                           = 120
  enable_http2                           = false
  ip_address_type                        = "ipv4"
  access_logs_prefix                     = "user_backend"
  access_logs_enabled                    = true
  ssl_policy                             = "ELBSecurityPolicy-2016-08"
  https_port                             = var.https_port
  http_port                              = var.http_port
  fixed_response_content_type            = "text/plain"
  fixed_response_message_body            = "ok"
  fixed_response_status_code             = "200"
  source_cidr_blocks                     = ["0.0.0.0/0"]

  target_group_port                      = 8080
  target_group_protocol                  = "HTTP"
  target_type                            = "ip"
  deregistration_delay                   = 600
  slow_start                             = 0
  health_check_path                      = "/health"
  health_check_healthy_threshold         = 3
  health_check_unhealthy_threshold       = 3
  health_check_timeout                   = 3
  health_check_interval                  = 60
  health_check_matcher                   = 200
  health_check_port                      = "traffic-port"
  health_check_protocol                  = "HTTP"
  listener_rule_priority                 = 1
  listener_rule_condition_field          = "path-pattern"
  listener_rule_condition_values         = ["/*"]
  enabled                                = true
  vpc_dns_zone_id                        = "Z019847324VXSJ595M5RD"
  vpc_dns_zone_name                      = "finverselabs.com."
  dns_host_entry                         = "user-backend"

  tags = {
    Terraform        = "True"
    env      = var.env
  }

  # WARNING: If in production environment, you should delete this parameter or change to true.
  enable_deletion_protection = false
}

module "s3_lb_log" {
  source                = "../../../s3-lb-log"
  name                  = "s3-lb-log-user-backend-${data.aws_caller_identity.current.account_id}"
  logging_target_bucket = module.s3_access_log.s3_bucket_id
  force_destroy         = true
}

module "s3_access_log" {
  source        = "../../../s3-access-log"
  name          = "s3-access-log-user-backend-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/ecs/${local.container_name}"

  tags = {
    env  = var.env
    Name = var.namespace
  }
}

data "aws_caller_identity" "current" {}
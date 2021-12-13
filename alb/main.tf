#---------------------------------------------------#
# ALB
#---------------------------------------------------#
resource "aws_alb" "alb" {
  count = var.enabled ? 1 : 0
  name  = var.name

  internal                   = var.internal
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.default[0].id]
  subnets                    = var.subnets
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection

  tags = var.tags
}

#---------------------------------------------------#
# Route 53
#---------------------------------------------------#
resource "aws_route53_record" "alb" {
  count    = var.enabled ? 1 : 0

  zone_id = var.vpc_dns_zone_id
  name    = "${var.dns_host_entry}.${var.vpc_dns_zone_name}"
  type    = "A"

  alias {
    name                   = aws_alb.alb.0.dns_name
    zone_id                = aws_alb.alb.0.zone_id
    evaluate_target_health = false
  }
}

#---------------------------------------------------#
# ALB Target Groups
#---------------------------------------------------#
resource "aws_alb_target_group" "alb" {
  count                = var.enabled ? 1 : 0
  name                 = var.name
  port                 = var.target_group_port
  protocol             = var.target_group_protocol
  vpc_id               = var.vpc_id
  target_type          = var.target_type
  deregistration_delay = var.deregistration_delay

  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }

  stickiness {
    type = var.stickiness_type
    enabled = var.stickiness_enabled
    cookie_name = var.stickiness_cookie_name
    cookie_duration = var.stickiness_cookie_duration
  }

  depends_on = [
    aws_alb.alb,
  ]
}

#---------------------------------------------------#
# ALB Listeners
#---------------------------------------------------#
resource "aws_alb_listener" "alb" {
  count = var.enabled ? 1 : 0

  load_balancer_arn = aws_alb.alb.0.arn
  port              = var.https_port
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.alb.0.arn
    type             = "forward"
  }
}

# NOTE on Security Groups and Security Group Rules:
# At this time you cannot use a Security Group with in-line rules in conjunction with any Security Group Rule resources.
# Doing so will cause a conflict of rule settings and will overwrite rules.
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "default" {
  count = var.enabled ? 1 : 0

  name   = local.security_group_name
  vpc_id = var.vpc_id

  tags = merge({ "Name" = local.security_group_name }, var.tags)
}

locals {
  security_group_name = "${var.name}-alb"
}

# https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "ingress_https" {
  count = local.enable_https_listener ? 1 : 0

  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = var.source_cidr_blocks
  security_group_id = aws_security_group.default[0].id
}

resource "aws_security_group_rule" "ingress_http" {
  count = var.enabled ? 1 : 0 && var.enable_http_listener ? 1 : 0

  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = var.source_cidr_blocks
  security_group_id = aws_security_group.default[0].id
}

resource "aws_security_group_rule" "egress" {
  count = var.enabled ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default[0].id
}

locals {
  enable_https_listener                  = var.enabled && var.enable_https_listener
  enable_http_listener                   = var.enabled && var.enable_http_listener && ! (var.enable_https_listener && var.enable_redirect_http_to_https_listener)
  enable_redirect_http_to_https_listener = var.enabled && var.enable_http_listener && (var.enable_https_listener && var.enable_redirect_http_to_https_listener)
}

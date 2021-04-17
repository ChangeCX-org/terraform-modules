module "certificate" {
  source      = "../"
  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.zone.id

  ttl = "120"

  enabled         = true
  timeouts_create = "5m"

  tags = {
    Environment = "prod"
    Name = "finverse"
  }
}

data "aws_route53_zone" "zone" {
  name = "${local.domain_name}."
}

locals {
  domain_name = "finverselabs.com"
}


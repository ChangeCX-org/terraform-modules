provider "aws" {
  region  = var.region
  profile = var.namespace
}

data "aws_region" "current" {}

module "vpc" {
  source = "../"

  name = var.name

  cidr = var.cidr

  azs                 = var.availability_zones
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  database_subnets    = var.database_subnets
  elasticache_subnets = var.elasticache_subnets
  redshift_subnets    = var.redshift_subnets

  create_database_subnet_route_table    = true
  create_elasticache_subnet_route_table = true
  create_redshift_subnet_route_table    = true

  single_nat_gateway = true
  enable_nat_gateway = true

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  public_subnet_tags = {
    Name = format("%s-subnet-public", var.name)
  }

  private_subnet_tags = {
    Name = format("%s-subnet-private", var.name)
  }

  tags = {
    Owner       = var.namespace
    Environment = var.env
  }

  vpc_tags = {
    Name = var.name
  }
}
provider "aws" {
  region  = "us-east-1"
  profile = "changecx"
}

module "vpc" {
  source = "../"

  name = "changecx-vpc-dev"

  cidr = "10.10.0.0/16"

  azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]
  redshift_subnets    = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]

  create_database_subnet_route_table    = true
  create_elasticache_subnet_route_table = true
  create_redshift_subnet_route_table    = true

  single_nat_gateway = true
  enable_nat_gateway = true

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  public_subnet_tags = {
    Name = "changecx-dev-public"
  }

  private_subnet_tags = {
    Name = "changecx-dev-private"
  }

  tags = {
    Owner       = "changecx"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "changecx-vpc-dev"
  }
}
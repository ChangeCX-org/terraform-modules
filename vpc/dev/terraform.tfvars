region = "us-east-1"

provider = "changecx"

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

namespace = "changecx"

env = "dev"

name = "changecx-vpc-dev"

cidr = "10.10.0.0/16"

private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]
redshift_subnets    = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]
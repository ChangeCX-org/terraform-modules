region            = "us-east-1"

vpc_name          = "changecx-vpc-dev"

namespace         = "changecx"

env               = "dev"

name              = "backend-service"

description       = "Backend Microservice"

image             = "350730217783.dkr.ecr.us-east-1.amazonaws.com/backend-service:dev"

cpu               = 256

memory            = 512

domain_name       = "changecx.io"

container_port    = 8080

container_name    = "backend-service-dev"

https_port        = 443

http_port         = 80

target_group_port = 8080

vpc_dns_zone_id   = "Z0206752GASZGQ1RDVGU"

vpc_dns_zone_name = "changecx.io."

dns_host_entry    = "backend-service"
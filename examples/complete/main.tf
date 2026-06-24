module "networking" {
  source = "../../"

  name = "platform-dev"

  create_transit_gateway = false

  route53_zones = {
    private = {
      name    = "platform.internal"
      private = true
      vpc_ids = ["vpc-12345678"]
    }
  }

  create_vpn_gateway = false

  tags = {
    Environment = "dev"
    Project     = "platform"
    ManagedBy   = "terraform"
  }
}

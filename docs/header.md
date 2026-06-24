# venky-terraform-module-networking

Generic Terraform module for provisioning networking connectivity resources.

## Features

- Transit Gateway with VPC attachments
- VPC Peering connections (same/cross-account, cross-region)
- Route53 hosted zones (public and private)
- VPN Gateway with customer gateways and site-to-site VPN
- Hybrid connectivity support (on-prem to cloud)

## Usage

```hcl
module "networking" {
  source = "git::https://github.com/venky1912/venky-terraform-module-networking.git?ref=v0.1.0"

  name = "platform-prod"

  create_transit_gateway = true
  transit_gateway_asn    = 64512

  transit_gateway_vpc_attachments = {
    prod = { vpc_id = module.vpc.vpc_id, subnet_ids = module.vpc.private_subnet_ids }
  }

  route53_zones = {
    private = {
      name    = "platform.internal"
      private = true
      vpc_ids = [module.vpc.vpc_id]
    }
  }

  create_vpn_gateway = true
  vpn_gateway_vpc_id = module.vpc.vpc_id

  customer_gateways = {
    office = { bgp_asn = 65001, ip_address = "203.0.113.1" }
  }

  tags = { Environment = "prod", ManagedBy = "terraform" }
}
```

################################################################################
# General
################################################################################

variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Transit Gateway
################################################################################

variable "create_transit_gateway" {
  description = "Whether to create a Transit Gateway"
  type        = bool
  default     = false
}

variable "transit_gateway_asn" {
  description = "Private ASN for the Transit Gateway"
  type        = number
  default     = 64512
}

variable "transit_gateway_auto_accept_shared_attachments" {
  description = "Auto accept shared attachments"
  type        = string
  default     = "enable"
}

variable "transit_gateway_vpc_attachments" {
  description = <<-EOT
    Map of VPC attachments for the Transit Gateway.
    Example:
    {
      prod = { vpc_id = "vpc-123", subnet_ids = ["subnet-1", "subnet-2"] }
    }
  EOT
  type = map(object({
    vpc_id     = string
    subnet_ids = list(string)
    tags       = optional(map(string), {})
  }))
  default = {}
}

################################################################################
# VPC Peering
################################################################################

variable "vpc_peering_connections" {
  description = <<-EOT
    Map of VPC peering connections to create.
    Example:
    {
      dev-to-shared = {
        peer_vpc_id   = "vpc-456"
        peer_owner_id = "123456789012"
        peer_region   = "eu-west-1"
        auto_accept   = true
      }
    }
  EOT
  type = map(object({
    peer_vpc_id   = string
    vpc_id        = string
    peer_owner_id = optional(string)
    peer_region   = optional(string)
    auto_accept   = optional(bool, false)
    tags          = optional(map(string), {})
  }))
  default = {}
}

################################################################################
# Route53
################################################################################

variable "route53_zones" {
  description = <<-EOT
    Map of Route53 hosted zones to create.
    Example:
    {
      private = {
        name    = "platform.internal"
        private = true
        vpc_ids = ["vpc-123"]
      }
      public = {
        name    = "platform.example.com"
        private = false
      }
    }
  EOT
  type = map(object({
    name    = string
    private = optional(bool, false)
    vpc_ids = optional(list(string), [])
    tags    = optional(map(string), {})
  }))
  default = {}
}

################################################################################
# VPN
################################################################################

variable "create_vpn_gateway" {
  description = "Whether to create a VPN Gateway"
  type        = bool
  default     = false
}

variable "vpn_gateway_vpc_id" {
  description = "VPC ID to attach VPN Gateway to"
  type        = string
  default     = ""
}

variable "vpn_gateway_asn" {
  description = "ASN for the VPN Gateway"
  type        = number
  default     = 65000
}

variable "customer_gateways" {
  description = <<-EOT
    Map of customer gateways for site-to-site VPN.
    Example:
    {
      office = {
        bgp_asn    = 65001
        ip_address = "1.2.3.4"
      }
    }
  EOT
  type = map(object({
    bgp_asn    = number
    ip_address = string
    tags       = optional(map(string), {})
  }))
  default = {}
}

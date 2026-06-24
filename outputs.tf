################################################################################
# Transit Gateway
################################################################################

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = try(aws_ec2_transit_gateway.this[0].id, null)
}

output "transit_gateway_arn" {
  description = "ARN of the Transit Gateway"
  value       = try(aws_ec2_transit_gateway.this[0].arn, null)
}

output "transit_gateway_vpc_attachment_ids" {
  description = "Map of Transit Gateway VPC attachment IDs"
  value       = { for k, v in aws_ec2_transit_gateway_vpc_attachment.this : k => v.id }
}

################################################################################
# VPC Peering
################################################################################

output "vpc_peering_connection_ids" {
  description = "Map of VPC peering connection IDs"
  value       = { for k, v in aws_vpc_peering_connection.this : k => v.id }
}

################################################################################
# Route53
################################################################################

output "route53_zone_ids" {
  description = "Map of Route53 zone IDs"
  value       = { for k, v in aws_route53_zone.this : k => v.zone_id }
}

output "route53_zone_name_servers" {
  description = "Map of Route53 zone name servers"
  value       = { for k, v in aws_route53_zone.this : k => v.name_servers }
}

################################################################################
# VPN
################################################################################

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].id, null)
}

output "customer_gateway_ids" {
  description = "Map of customer gateway IDs"
  value       = { for k, v in aws_customer_gateway.this : k => v.id }
}

output "vpn_connection_ids" {
  description = "Map of VPN connection IDs"
  value       = { for k, v in aws_vpn_connection.this : k => v.id }
}

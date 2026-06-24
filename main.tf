################################################################################
# Transit Gateway
################################################################################

resource "aws_ec2_transit_gateway" "this" {
  count = var.create_transit_gateway ? 1 : 0

  amazon_side_asn                 = var.transit_gateway_asn
  auto_accept_shared_attachments  = var.transit_gateway_auto_accept_shared_attachments
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"

  tags = merge(var.tags, {
    Name = "${var.name}-tgw"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.create_transit_gateway ? var.transit_gateway_vpc_attachments : {}

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name}-tgw-${each.key}"
  })
}

################################################################################
# VPC Peering
################################################################################

resource "aws_vpc_peering_connection" "this" {
  for_each = var.vpc_peering_connections

  vpc_id        = each.value.vpc_id
  peer_vpc_id   = each.value.peer_vpc_id
  peer_owner_id = try(each.value.peer_owner_id, null)
  peer_region   = try(each.value.peer_region, null)
  auto_accept   = try(each.value.auto_accept, false)

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name}-peer-${each.key}"
  })
}

################################################################################
# Route53 Hosted Zones
################################################################################

resource "aws_route53_zone" "this" {
  for_each = var.route53_zones

  name = each.value.name

  dynamic "vpc" {
    for_each = each.value.private ? each.value.vpc_ids : []
    content {
      vpc_id = vpc.value
    }
  }

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name}-${each.key}"
  })
}

################################################################################
# VPN Gateway
################################################################################

resource "aws_vpn_gateway" "this" {
  count = var.create_vpn_gateway ? 1 : 0

  vpc_id          = var.vpn_gateway_vpc_id
  amazon_side_asn = var.vpn_gateway_asn

  tags = merge(var.tags, {
    Name = "${var.name}-vpn-gw"
  })
}

resource "aws_customer_gateway" "this" {
  for_each = var.customer_gateways

  bgp_asn    = each.value.bgp_asn
  ip_address = each.value.ip_address
  type       = "ipsec.1"

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name = "${var.name}-cgw-${each.key}"
  })
}

resource "aws_vpn_connection" "this" {
  for_each = var.create_vpn_gateway ? var.customer_gateways : {}

  vpn_gateway_id      = aws_vpn_gateway.this[0].id
  customer_gateway_id = aws_customer_gateway.this[each.key].id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = merge(var.tags, {
    Name = "${var.name}-vpn-${each.key}"
  })
}

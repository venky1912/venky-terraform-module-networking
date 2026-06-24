<!-- BEGIN_TF_DOCS -->
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

## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_customer_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpn_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for all resources | `string` | n/a | yes |
| <a name="input_create_transit_gateway"></a> [create\_transit\_gateway](#input\_create\_transit\_gateway) | Whether to create a Transit Gateway | `bool` | `false` | no |
| <a name="input_create_vpn_gateway"></a> [create\_vpn\_gateway](#input\_create\_vpn\_gateway) | Whether to create a VPN Gateway | `bool` | `false` | no |
| <a name="input_customer_gateways"></a> [customer\_gateways](#input\_customer\_gateways) | Map of customer gateways for site-to-site VPN.<br/>Example:<br/>{<br/>  office = {<br/>    bgp\_asn    = 65001<br/>    ip\_address = "1.2.3.4"<br/>  }<br/>} | <pre>map(object({<br/>    bgp_asn    = number<br/>    ip_address = string<br/>    tags       = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_route53_zones"></a> [route53\_zones](#input\_route53\_zones) | Map of Route53 hosted zones to create.<br/>Example:<br/>{<br/>  private = {<br/>    name    = "platform.internal"<br/>    private = true<br/>    vpc\_ids = ["vpc-123"]<br/>  }<br/>  public = {<br/>    name    = "platform.example.com"<br/>    private = false<br/>  }<br/>} | <pre>map(object({<br/>    name    = string<br/>    private = optional(bool, false)<br/>    vpc_ids = optional(list(string), [])<br/>    tags    = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_asn"></a> [transit\_gateway\_asn](#input\_transit\_gateway\_asn) | Private ASN for the Transit Gateway | `number` | `64512` | no |
| <a name="input_transit_gateway_auto_accept_shared_attachments"></a> [transit\_gateway\_auto\_accept\_shared\_attachments](#input\_transit\_gateway\_auto\_accept\_shared\_attachments) | Auto accept shared attachments | `string` | `"enable"` | no |
| <a name="input_transit_gateway_vpc_attachments"></a> [transit\_gateway\_vpc\_attachments](#input\_transit\_gateway\_vpc\_attachments) | Map of VPC attachments for the Transit Gateway.<br/>Example:<br/>{<br/>  prod = { vpc\_id = "vpc-123", subnet\_ids = ["subnet-1", "subnet-2"] }<br/>} | <pre>map(object({<br/>    vpc_id     = string<br/>    subnet_ids = list(string)<br/>    tags       = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_peering_connections"></a> [vpc\_peering\_connections](#input\_vpc\_peering\_connections) | Map of VPC peering connections to create.<br/>Example:<br/>{<br/>  dev-to-shared = {<br/>    peer\_vpc\_id   = "vpc-456"<br/>    peer\_owner\_id = "123456789012"<br/>    peer\_region   = "eu-west-1"<br/>    auto\_accept   = true<br/>  }<br/>} | <pre>map(object({<br/>    peer_vpc_id   = string<br/>    vpc_id        = string<br/>    peer_owner_id = optional(string)<br/>    peer_region   = optional(string)<br/>    auto_accept   = optional(bool, false)<br/>    tags          = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_vpn_gateway_asn"></a> [vpn\_gateway\_asn](#input\_vpn\_gateway\_asn) | ASN for the VPN Gateway | `number` | `65000` | no |
| <a name="input_vpn_gateway_vpc_id"></a> [vpn\_gateway\_vpc\_id](#input\_vpn\_gateway\_vpc\_id) | VPC ID to attach VPN Gateway to | `string` | `""` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_customer_gateway_ids"></a> [customer\_gateway\_ids](#output\_customer\_gateway\_ids) | Map of customer gateway IDs |
| <a name="output_route53_zone_ids"></a> [route53\_zone\_ids](#output\_route53\_zone\_ids) | Map of Route53 zone IDs |
| <a name="output_route53_zone_name_servers"></a> [route53\_zone\_name\_servers](#output\_route53\_zone\_name\_servers) | Map of Route53 zone name servers |
| <a name="output_transit_gateway_arn"></a> [transit\_gateway\_arn](#output\_transit\_gateway\_arn) | ARN of the Transit Gateway |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | ID of the Transit Gateway |
| <a name="output_transit_gateway_vpc_attachment_ids"></a> [transit\_gateway\_vpc\_attachment\_ids](#output\_transit\_gateway\_vpc\_attachment\_ids) | Map of Transit Gateway VPC attachment IDs |
| <a name="output_vpc_peering_connection_ids"></a> [vpc\_peering\_connection\_ids](#output\_vpc\_peering\_connection\_ids) | Map of VPC peering connection IDs |
| <a name="output_vpn_connection_ids"></a> [vpn\_connection\_ids](#output\_vpn\_connection\_ids) | Map of VPN connection IDs |
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | ID of the VPN Gateway |
<!-- END_TF_DOCS -->
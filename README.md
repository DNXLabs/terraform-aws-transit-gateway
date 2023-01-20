# terraform-aws-transit-gateway

This module creates the transit gateway network resources.

The following resources will be created:
 - Direct Connect Data resource
 - AWS Organization Data resource
 - Direct Connect Gateway
 - Direct Connect Gateway Association   
 - Direct Connect Transit Virtual Interface
 - Transit Gateway
 - Transit Gateway Blackhole Route
 - Transit Gateway Route
 - Transit Gateway VPC Attachment
 - Resource Access Manager (RAM) Resource Share
 - Resource Access Manager (RAM) Resource Association
 - Resource Access Manager (RAM) Principal Association
 - SSM Security String Parameter

## Execution Diagram of `terraform-transit-gateway`
![](_docs/assets/TransitGateway.png)

## Usage

```hcl
module "transit_gateway" {
  source = "git::https://github.com/DNXLabs/terraform-aws-transit-gateway.git?ref=1.0.0"

  name                       = local.workspace.org_name
  account_name               = local.workspace.account_name
  transit_gateway_account_id = local.workspace.transit_gateway.attachment.transit_gateway_account_id
  allowed_prefixes           = try(local.workspace.transit_gateway.allowed_prefixes, [])
  dns_support                = try(local.workspace.transit_gateway.dns_support, "enable")
  attachment                 = try(local.workspace.transit_gateway.attachment.enabled, false)
  transit_gateway_enabled    = try(local.workspace.transit_gateway.enabled, false)
  vpc_id                     = module.network[0].vpc_id
  subnet_ids                 = module.network[0].private_subnet_ids
  private_route_table_id     = module.network[0].private_route_table_id[0]
  public_route_table_id      = module.network[0].public_route_table_id
  private_network_acl_id     = module.network[0].private_nacl_id
  public_network_acl_id      = module.network[0].public_nacl_id
  dx_connection              = try(local.workspace.transit_gateway.dx_connection, [])
  direct_connect_gateway_asn = try(local.workspace.transit_gateway.direct_connect_gateway_asn, "64512")
  transit_gateway_asn        = try(local.workspace.transit_gateway.transit_gateway_asn, "64513")
  public_route               = try(local.workspace.transit_gateway.attachment.public_route, [])
  private_route              = try(local.workspace.transit_gateway.attachment.private_route, [])
}
```

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 3.56.0 |
| random | >= 2.1.0 |
| tls | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.56.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_name | Name of the AWS account. | `string` | n/a | yes |
| allowed\_prefixes | VPC prefixes (CIDRs) to advertise to the Direct Connect gateway. Defaults to the CIDR block of the VPC associated with the Virtual Gateway. To enable drift detection, must be configured. | `list(string)` | `[]` | no |
| attachment | Create VPC Attachment to Transit Gateway | `bool` | `false` | no |
| default\_route\_table\_association | Whether resource attachments are automatically associated with the default association route table. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |
| default\_route\_table\_propagation | Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |
| direct\_connect\_gateway\_asn | The ASN to be configured on the Amazon side of the connection. The ASN must be in the private range of 64,512 to 65,534 or 4,200,000,000 to 4,294,967,294. | `number` | n/a | yes |
| dns\_support | Whether DNS support is enabled. Valid values: disable, enable. Default value: enable. | `string` | `"enable"` | no |
| dx\_connection | The name of the connection to retrieve. | `list(any)` | `[]` | no |
| name | Name prefix for the resources of this stack | `string` | n/a | yes |
| private\_network\_acl\_id | Private Network ACL ID | `string` | n/a | yes |
| private\_route | Private Destination CIDR blocks for NACL definition | `list(any)` | n/a | yes |
| private\_route\_table\_id | Private Route Table Identifier | `string` | n/a | yes |
| public\_network\_acl\_id | Public Network ACL ID | `string` | n/a | yes |
| public\_route | Public Destination CIDR blocks for NACL definition | `list(any)` | n/a | yes |
| public\_route\_table\_id | Public Route Table Identifier | `string` | n/a | yes |
| secure\_network\_acl\_id | Secure Network ACL ID | `string` | n/a | yes |
| secure\_route | Secure Destination CIDR blocks for NACL definition | `list(any)` | n/a | yes |
| secure\_route\_table\_id | Secure Route Table Identifier | `string` | n/a | yes |
| subnet\_ids | Identifiers of EC2 Subnets. | `list(any)` | `[]` | no |
| tags | Extra tags to attach to resources | `map(string)` | `{}` | no |
| transit\_gateway\_account\_id | Identifier of the AWS account that owns the EC2 Transit Gateway. | `string` | n/a | yes |
| transit\_gateway\_asn | Private Autonomous System Number (ASN) for the Amazon side of a BGP session. The range is 64512 to 65534 for 16-bit ASNs and 4200000000 to 4294967294 for 32-bit ASNs. Default value: 64512. | `number` | `64512` | no |
| transit\_gateway\_default\_route\_table\_association | Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: true. | `bool` | `true` | no |
| transit\_gateway\_default\_route\_table\_propagation | Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: true. | `bool` | `true` | no |
| transit\_gateway\_enabled | Enable or disable Transit Gateway | `bool` | n/a | yes |
| vpc\_id | Identifier of EC2 VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ram\_resource\_share\_id | RAM resource share ID |
| subnet\_route\_ids | Subnet route identifiers combined with destinations |
| transit\_gateway\_arn | Transit Gateway ARN |
| transit\_gateway\_association\_default\_route\_table\_id | Transit Gateway association default route table ID |
| transit\_gateway\_id | Transit Gateway ID |
| transit\_gateway\_propagation\_default\_route\_table\_id | Transit Gateway propagation default route table ID |
| transit\_gateway\_route\_ids | Transit Gateway route identifiers combined with destinations |
| transit\_gateway\_route\_table | RAM resource share ID |
| transit\_gateway\_route\_table\_id | Transit Gateway route table ID |
| transit\_gateway\_vpc\_attachment | RAM resource share ID |
| transit\_gateway\_vpc\_attachment\_ids | Transit Gateway VPC attachment IDs |

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-transit-gateway/blob/master/LICENSE) for full details.

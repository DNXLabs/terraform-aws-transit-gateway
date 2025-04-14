module "transit_gateway" {
  source = "git::https://github.com/DNXLabs/terraform-aws-transit-gateway.git?ref=1.0.0"

  name                               = local.workspace.org_name
  account_name                       = local.workspace.account_name
  transit_gateway_account_id         = local.workspace.transit_gateway.attachment.transit_gateway_account_id
  allowed_prefixes                   = try(local.workspace.transit_gateway.allowed_prefixes, [])
  dns_support                        = try(local.workspace.transit_gateway.dns_support, "enable")
  security_group_referencing_support = try(local.workspace.transit_gateway.security_group_referencing_support, "disable")
  attachment                         = try(local.workspace.transit_gateway.attachment.enabled, false)
  transit_gateway_enabled            = try(local.workspace.transit_gateway.enabled, false)
  vpc_id                             = module.network[0].vpc_id
  subnet_ids                         = module.network[0].private_subnet_ids
  private_route_table_id             = module.network[0].private_route_table_id[0]
  public_route_table_id              = module.network[0].public_route_table_id
  secure_route_table_id              = module.network[0].secure_route_table_id
  private_network_acl_id             = module.network[0].private_nacl_id
  public_network_acl_id              = module.network[0].public_nacl_id
  secure_network_acl_id              = module.network[0].secure_nacl_id
  dx_connection                      = try(local.workspace.transit_gateway.dx_connection, [])
  direct_connect_gateway_asn         = try(local.workspace.transit_gateway.direct_connect_gateway_asn, "64512")
  transit_gateway_asn                = try(local.workspace.transit_gateway.transit_gateway_asn, "64513")
  public_route                       = try(local.workspace.transit_gateway.attachment.public_route, [])
  private_route                      = try(local.workspace.transit_gateway.attachment.private_route, [])
  secure_route                       = try(local.workspace.transit_gateway.attachment.secure_route, [])

}

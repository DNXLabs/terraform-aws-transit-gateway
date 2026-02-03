resource "aws_ram_resource_share" "default" {
  count = var.transit_gateway_enabled || var.transit_gateway_id != null ? 1 : 0

  name                      = "${var.name}-tgw-ram"
  allow_external_principals = true

  tags = merge(
    var.tags,
    {
      "Name"    = "${var.name}-tgw-ram"
      "EnvName" = var.account_name
    },
  )
}

resource "aws_ram_resource_association" "default" {
  count = var.transit_gateway_enabled || var.transit_gateway_id != null ? 1 : 0

  resource_arn       = var.transit_gateway_id != null ? "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:transit-gateway/${var.transit_gateway_id}" : aws_ec2_transit_gateway.default[0].arn
  resource_share_arn = aws_ram_resource_share.default[0].arn
}

resource "aws_ram_principal_association" "default" {
  count = (var.transit_gateway_enabled || var.transit_gateway_id != null) && var.ram_organization_association ? 1 : 0

  principal          = data.aws_organizations_organization.default.arn
  resource_share_arn = aws_ram_resource_share.default[0].arn
}

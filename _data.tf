data "aws_organizations_organization" "default" {}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ec2_transit_gateway" "default" {
  count = try(var.attachment, false) ? 1 : 0

  filter {
    name   = "owner-id"
    values = [var.transit_gateway_account_id]
  }
}

data "aws_dx_connection" "default" {
  for_each = {
    for dx_connection in var.dx_connection : dx_connection.name => dx_connection
  }

  name = each.value.name
}

data "aws_ec2_transit_gateway_dx_gateway_attachment" "default" {
  count = length(try(var.dx_connection, [])) > 0 ? 1 : 0


  transit_gateway_id = aws_ec2_transit_gateway.default[0].id
  dx_gateway_id      = aws_dx_gateway.default[0].id
}

data "aws_ssm_parameter" "bgp_auth_key" {
  for_each = {
    for dx_connection in var.dx_connection : dx_connection.name => dx_connection
  }

  name            = "/dx/transit-vif/${var.account_name}/${each.value.name}/bgp_auth_key"
  with_decryption = true
}

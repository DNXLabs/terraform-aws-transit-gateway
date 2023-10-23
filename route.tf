resource "aws_route" "private" {
  for_each = {
    for route in var.private_route : route.cidr => route
    if try(var.attachment, false) == true && route.cidr != var.vpc_cidr
  }

  route_table_id         = var.private_route_table_id
  destination_cidr_block = each.value.cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.default[0].id
}
resource "aws_route" "public" {
  for_each = {
    for route in var.public_route : route.cidr => route
    if try(var.attachment, false) == true && route.cidr != var.vpc_cidr
  }

  route_table_id         = var.public_route_table_id
  destination_cidr_block = each.value.cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.default[0].id
}

resource "aws_route" "secure" {
  for_each = {
    for route in var.secure_route : route.cidr => route
    if try(var.attachment, false) == true && route.cidr != var.vpc_cidr
  }

  route_table_id         = var.secure_route_table_id
  destination_cidr_block = each.value.cidr
  transit_gateway_id     = data.aws_ec2_transit_gateway.default[0].id
}

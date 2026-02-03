locals {
  # Use provided TGW ID, or created TGW ID, or lookup via data source
  transit_gateway_id = (
    var.transit_gateway_id != null ? var.transit_gateway_id :
    var.transit_gateway_enabled ? aws_ec2_transit_gateway.default[0].id :
    data.aws_ec2_transit_gateway.default[0].id
  )

  private_inbound_ports = distinct(flatten([
    for each_cidr in var.private_route : [
      for each_port in each_cidr.nacl_inbound_ports : {
        cidr = each_cidr.cidr
        port = each_port
        protocol = each_cidr.protocol
      }
  ]]))

  private_outbound_ports = distinct(flatten([
    for each_cidr in var.private_route : [
      for each_port in each_cidr.nacl_outbound_ports : {
        cidr = each_cidr.cidr
        port = each_port
        protocol = each_cidr.protocol
      }
  ]]))

  public_inbound_ports = distinct(flatten([
    for each_cidr in var.public_route : [
      for each_port in each_cidr.nacl_inbound_ports : {
        cidr = each_cidr.cidr
        port = each_port
        protocol = each_cidr.protocol
      }
  ]]))

  public_outbound_ports = distinct(flatten([
    for each_cidr in var.public_route : [
      for each_port in each_cidr.nacl_outbound_ports : {
        cidr = each_cidr.cidr
        port = each_port
        protocol = each_cidr.protocol
      }
  ]]))

  secure_inbound_ports = distinct(flatten([
    for each_cidr in var.secure_route : [
      for each_port in each_cidr.nacl_inbound_ports : {
        cidr = each_cidr.cidr
        port = each_port
        protocol = each_cidr.protocol
      }
  ]]))

  secure_outbound_ports = distinct(flatten([
    for each_cidr in var.secure_route : [
      for each_port in each_cidr.nacl_outbound_ports : {
        cidr = each_cidr.cidr
        port = each_port
        protocol = each_cidr.protocol
      }
  ]]))
}

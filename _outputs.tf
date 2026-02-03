output "transit_gateway_id" {
  value       = var.transit_gateway_id != null ? var.transit_gateway_id : (var.transit_gateway_enabled ? try(aws_ec2_transit_gateway.default[0].id, null) : null)
  description = "Transit Gateway ID"
}

output "transit_gateway_default_route_table_id" {
  value = var.transit_gateway_enabled ? aws_ec2_transit_gateway.default.*.association_default_route_table_id : null
  description = "Transit Gateway route table id default"
}

output "transit_gateway_account_owner_id" {
  value = var.transit_gateway_enabled ? aws_ec2_transit_gateway.default.*.owner_id : null
  description = "Transit Gateway AWS account ID owner"
}

output "transit_gateway_cidr_blocks" {
  value = var.transit_gateway_enabled ? try(aws_ec2_transit_gateway.default.*.transit_gateway_cidr_blocks, []) : null
  description = "Transit Gateway CIDR blocks"
}

output "transit_attachment_id" {
  value       =  var.attachment ? aws_ec2_transit_gateway_vpc_attachment.default.*.id : null
  description = "Transit Gateway attachment"
}

output "transit_attachment_account_owner_id" {
  value       =  var.attachment ? aws_ec2_transit_gateway_vpc_attachment.default.*.vpc_owner_id : null
  description = "Transit Gateway attachment AWS Account owner"
}

output "public_nacls" {
  value = {
    "acl" : var.public_network_acl_id
     "egress" : {
      "public_out_requester_to_accepter" : length(var.public_network_acl_id) > 0 ? aws_network_acl_rule.public_out_requester_to_accepter : {}
    }
    "ingress" : {
      "public_in_requester_from_accepter" : length(var.public_network_acl_id) > 0 ? aws_network_acl_rule.public_in_requester_from_accepter : {}
    }
  }
}

output "private_nacls" {
  value = {
    "acl" : var.private_network_acl_id
    "egress" : {
      "private_out_requester_from_accepter" : length(var.private_network_acl_id) > 0 ? aws_network_acl_rule.private_out_requester_to_accepter : {}
    }
    "ingress" : {
      "private_in_requester_from_accepter" : length(var.private_network_acl_id) > 0 ? aws_network_acl_rule.private_in_requester_from_accepter : {}
    }
  }
}

output "secure_nacls" {
  value = {
    "acl" : var.secure_network_acl_id
     "egress" : {
      "secure_out_requester_from_accepter" : length(var.secure_network_acl_id) > 0 ? aws_network_acl_rule.secure_out_requester_to_accepter : {}
    }
    "ingress" : {
      "secure_in_requester_from_accepter" : length(var.secure_network_acl_id) > 0 ? aws_network_acl_rule.secure_out_requester_to_accepter : {}
    }
  }
}
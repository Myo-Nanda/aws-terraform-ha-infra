# This module creates a Security Group with specified rules in a given VPC.
resource "aws_security_group" "Security_Group" {
  name        = var.sg_name
  description = var.sg_description

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.sg_name} Security Group"
  }
}

# Create security group rules based on the provided map of rules in the variable "sg_rule". 
# Separate resources are created for rules with cidr_blocks and rules with source_security_group_id to handle the different attributes required for each type of rule.

# Create security group rules for rules that specify cidr_blocks
resource "aws_security_group_rule" "SG_cidr_rule" {
  for_each          = { for k, v in var.sg_rule : k => v if v.cidr_blocks != null } # Filter rules that have cidr_blocks defined
  security_group_id = aws_security_group.Security_Group.id
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

# Create security group rules for rules that specify source_security_group_id instead of cidr_blocks
resource "aws_security_group_rule" "SG_sourceID_rule" {
  for_each                 = { for k, v in var.sg_rule : k => v if v.cidr_blocks == null && v.source_security_group_id != null } # Filter rules that do not have cidr_blocks defined and source_security_group_id defined
  security_group_id        = aws_security_group.Security_Group.id
  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
}
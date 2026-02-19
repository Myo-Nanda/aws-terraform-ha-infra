resource "aws_security_group" "DEV_SG" {
  name        = var.sg_name
  description = var.sg_description

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.sg_name} Security Group"
  }
}

resource "aws_security_group_rule" "SG_cidr_rule" {
  for_each          = { for k, v in var.sg_rule : k => v if v.cidr_blocks != null }
  security_group_id = aws_security_group.DEV_SG.id
  type              = each.value.type
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "aws_security_group_rule" "SG_sourceID_rule" {
  for_each                 = { for k, v in var.sg_rule : k => v if v.cidr_blocks == null }
  security_group_id        = aws_security_group.DEV_SG.id
  type                     = each.value.type
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source_security_group_id
}
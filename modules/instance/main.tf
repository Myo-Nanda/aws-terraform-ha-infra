resource "aws_key_pair" "Dev_VM_Key" {
  key_name   = var.key_name
  public_key = file(var.key_path)
}

resource "aws_instance" "Dev_Instance" {
  for_each = toset(var.subnet_id)
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = each.key
  vpc_security_group_ids = [aws_security_group.Instance_SG.id]

  user_data = file(var.custome_script)

  tags = {
    Name = "${var.tag_value} VM ${each.key}"
  }
}
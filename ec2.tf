resource "aws_instance" "my_app_eg1" {
  for_each = local.web_servers

  ami           = "ami-07309549f34230bcd"
  instance_type = each.value.machine_type
  key_name      = "devops"
  subnet_id     = each.value.subnet_id

  vpc_security_group_ids = [aws_security_group.ec2_eg1.id]

  tags = {
    Name = each.key
  }
}

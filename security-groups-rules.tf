locals {
  web_servers = {
    my-app-00 = {
        machine_type = "t2.micro"
        subnet_id = aws_subnet.private_us_east_1a.id
    }
    my-app-01 = {
        machine_type = "t2.micro"
        subnet_id = aws_subnet.private_us_east_1b.id
    }
  }
}   

resource "aws_security_group" "ec2_eg1" {
  name   = "ec2-eg1"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "alb_eg1" {
  name   = "alb-eg1"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_ec2_traffic" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1.id
  source_security_group_id = aws_security_group.alb_eg1.id
}

resource "aws_security_group_rule" "ingress_ec2_health_check" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1.id
  source_security_group_id = aws_security_group.alb_eg1.id
}

# resource "aws_security_group_rule" "full_egress_ec2" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   security_group_id = aws_security_group.ec2_eg1.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }

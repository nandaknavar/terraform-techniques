resource "aws_security_group" "main" {
  name_prefix = "main-"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    "Name" = "main"
  }
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  for_each = {
    vpc_1 = "10.1.0.0/16"
    vpc_2 = "10.2.0.0/16"
    local = "10.10.0.0/16"
  }

  security_group_id = aws_security_group.main.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  description = "${each.key} - allow HTTPS"
  cidr_ipv4   = each.value

  tags = {
    "Name" = each.key
  }
}
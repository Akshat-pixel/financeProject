resource "aws_security_group" "finance_sg" {
  name        = "finance_sg"
  description = "Security group for finance instances"
  tags = {
    Name = "finance_project"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sshIntoInstanceFromMyIP" {
  security_group_id = aws_security_group.finance_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "205.254.168.136/32"
  description       = "Allow ssh from my IP"
}

resource "aws_vpc_security_group_ingress_rule" "httpAccessFromMyIP" {
  security_group_id = aws_security_group.finance_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "205.254.168.136/32"
  description       = "Allow HTTP access from my IP"
}

resource "aws_vpc_security_group_ingress_rule" "sshFromAnsibleController" {
  security_group_id            = aws_security_group.finance_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
  referenced_security_group_id = "sg-080a1dd7f1e3dc47f"
  description                  = "Allow SSH access from Ansible controller using private IP"
}

resource "aws_vpc_security_group_egress_rule" "httpAccessOutbound" {
  security_group_id = aws_security_group.finance_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow outbound HTTP access to the internet"
}

resource "aws_vpc_security_group_egress_rule" "httpsAccessOutbound" {
  security_group_id = aws_security_group.finance_sg.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
  description       = "Allow outbound HTTPS access to the internet"
}
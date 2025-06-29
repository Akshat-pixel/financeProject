resource "aws_instance" "finance_instance" {
  ami                    = "ami-020cba7c55df1f615"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.finance_sg.id]
  key_name               = aws_key_pair.finance_key.key_name
  availability_zone      = "us-east-1a"
  tags = {
    Name = "finance_project"
  }
}

resource "aws_ec2_instance_state" "inance_instance_state" {
  instance_id = aws_instance.finance_instance.id
  state       = "running"
}

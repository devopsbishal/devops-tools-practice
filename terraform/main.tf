# retrieve information about existing default vpc from aws 
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "allow_ssh"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_key_pair" "test-web-key" {
  key_name   = "test-server-key"
  public_key = file("/Users/bishalrayamajhi/.ssh/testing_key.pub")
}

resource "aws_instance" "test-web-server" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.test-web-key.id
  tags = {
    Name = "terraform-testing-server"
  }
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}

output "name" {
  value       = aws_instance.test-web-server.public_ip
  description = "Show the pubic ip address of ec2 instance"
}
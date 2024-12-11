resource "aws_instance" "test-web-server" {
  ami = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-testing-server"
  }
}
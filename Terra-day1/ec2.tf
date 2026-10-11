#key pair
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-ec2-key"
  public_key = file("terra-key.pub")

  tags = {
    Name = "terraform-ec2-key"
  }
}


#vpc
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

#security group

resource "aws_security_group" "my_security_group" {
  name        = "terra-auto-sg-1"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id #interpolation to get the default vpc id

}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.my_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" #allow all protocols

}
#instance configuration
resource "aws_instance" "my_instance" {
  key_name               = aws_key_pair.terraform_key.key_name #interpolation to get the key name from the key pair resource
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  ami                    = "ami-0b6d9d3d33ba97d99" #ubuntu 26.04 AMI # is need to be updated based on the region
  instance_type          = "t3.micro"


  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }


  tags = {
    Name = "My-tera EC2 Instance"
  }
}
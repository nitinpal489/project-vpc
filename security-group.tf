resource "aws_security_group" "apache1" {
  name        = "apache1"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0c6999fc87152a4a8"
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache"
  }
}


# # apache:
resource "aws_instance" "apache" {
  ami           = "ami-074dc0a6f6c764218"
  instance_type = "t2.micro"
  #subnet_id              = aws_subnet.stag-public1[0].id
  #subnet_id              = "subnet-01f67da2e4bcb58df"
  vpc_security_group_ids = [aws_security_group.apache1.id]
  key_name               = "nitin"

  user_data = <<EOF
             #!/bin/bash
             yum update -y
             yum install httpd -y 
             systemctl enable httpd
             systemctl start httpd
       EOF




  tags = {
    Name = "apache"
  }
}
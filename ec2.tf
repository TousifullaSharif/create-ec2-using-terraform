provider "aws" {
  region = "us-east-1"
  access_key = "AKIA2LUIDZ32HR6DUDWJ"
  secret_key = "g9i40UDzpZLdYjjNAkOM5+GpRI0is1/Iw5/zQrM9"
}

resource "aws_instance" "example" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]
  key_name = aws_key_pair.example.key_name

  tags = {
    Name = "Terraform-ec2"
  }
}

resource "aws_key_pair" "example" {
  
  public_key = file("~/example-key-pair.pub")
}

resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

terraform {
  backend "s3" {
    bucket = "ts-ec2-bucket"
    key    = "ts-ec2-bucket"
    region = "us-east-1"
  }
}


output "public_ip" {
  value = aws_instance.example.public_ip
}

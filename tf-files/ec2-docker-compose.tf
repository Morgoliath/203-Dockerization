//This Terraform Template creates 1 Docker Machines on EC2 Instances
//Docker-compose Machines will run on Amazon Linux 2 with custom security group
//allowing SSH (22) and HTTP (80) connections from anywhere.
//User needs to select appropriate key name when launching the instance.

provider "aws" {
  region = "us-east-1"
  //  If you have entered your credentials in AWS CLI before, you do not need to use these arguments.
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "docker-server" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  key_name        = "morgoliathkey"
  //  Write your pem file name
  vpc_security_group_ids = [aws_security_group.sec-gr.id]
  tags = {
    Name = "Web Server of Bookstore"
  }
  user_data = file("user-data.sh")
}


  resource "aws_security_group" "sec-gr" {
    name = "docker-compose-sec-group"
    tags = {
      Name = "docker-compose-sec-group"
    }
    ingress {
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 5000
      protocol    = "tcp"
      to_port     = 5000
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      protocol    = -1
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
output "docker-compose-public-ip" {
  value = "http://${aws_instance.docker-server.public_ip}" 
}
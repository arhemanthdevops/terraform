provider "aws" {
  region = "ap-south-1"
}

# defining an instance setup
resource "aws_instance" "pipeline" {
  ami           = "ami-0449c34f967dbf18a"
  instance_type = "t2.micro"
  key_name      = "dpp"

  tags = {
    Name = "my_pipe_instance"
  }

  vpc_security_group_ids = [aws_security_group.pipe.id]  # Reference to the security group
}

# creating security group for an instance
resource "aws_security_group" "pipe" {
  name        = "pipe"
  description = "Allow ssh traffic"

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

# creating a VPC for the instance
resource "aws_vpc" "my_pipe_vpc" {
  cidr_block             = "10.0.0.0/16"
  enable_dns_support     = true
  enable_dns_hostnames   = true

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.my_pipe_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ap-south-1a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.my_pipe_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_b"
  }
}

# Specify the provider for AWS with the region setting
provider "aws" {
  region = "us-east-1"
}

# Define a data source for fetching the most recent Amazon Machine Image (AMI)
data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  
  # Specify filters to narrow down the AMI search
  filter {
    name   = "architecture"
    values = ["x86_64"]  # Change architecture to x86_64 for t2.micro support
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

# Define an AWS EC2 instance resource
resource "aws_instance" "this" {
  # Use the AMI ID obtained from the data source
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"  # Use t2.micro instance type

  # Assign tags to the EC2 instance
  tags = {
    Name = "First_terraform"
  }
}

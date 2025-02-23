provider "aws" {
  region = "eu-central-1"
}

resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible-key"
  public_key = file("~/.ssh/ansible-key.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-06ee6255945a96aba"  # Replace with your region's AMI
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ansible_key.key_name 
  security_groups = ["default"]
  tags = {
    Name = "Terraform-EC2"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}

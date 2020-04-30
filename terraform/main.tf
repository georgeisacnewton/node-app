
//connections.tf
variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  region = "us-east-2"
  access_key = ""
  secret_key = ""
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlvZq7Y2gWeXuD/xxzlo5lYXw5ZMhlusqg/5F3K1KvW7cHi9sXOf76QI0jAKijaFqMcMyNpjaMuEOMSgA+MoxPh9CSkfVgGt3toBvwVEs/7fFif7dL6LuWi+52Pmizh7nUg3dRbuWPjmT9jlnnmV4A4A8K/FN/Zjb5lQofsM/fRY+nGq/UFU+bJu/ti5V15ExJoB9cK3cvDComD0W+MIWBWttrCF2DsEF2TB2Ymex4c2iF/ebVTgoxpFyCkjVPEc58/q8lvoLyiN7CovKf7ThjOMrDVxTl+6cCWfP2WHP8634wvQ6ChWFHOtvl7EduPOrU121fhRqyUvNnJxcRAKt/"
}

resource "aws_vpc" "test-env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

}

resource "aws_subnet" "subnet-uno" {
  cidr_block = "10.0.1.0/24"
  vpc_id = "${aws_vpc.test-env.id}"
  availability_zone = "us-east-2a"
}


resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
vpc_id = "${aws_vpc.test-env.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

data "aws_ami" "latest-ami" {
most_recent = true
owners = ["406461302707"] 
  filter {
    name   = "name"
    values = ["ami-base-001"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

resource "aws_instance" "test-ec2-instance" {
  ami = "${data.aws_ami.latest-ami.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  subnet_id = "${aws_subnet.subnet-uno.id}"
  key_name = "deployer-key"
}



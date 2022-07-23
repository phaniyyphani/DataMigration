terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region    = "us-west-2"
  shared_credentials_files = [".aws/credentials.txt"]
  profile	= "624301448388"
}

resource "aws_vpc" "tst-vpc" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "tat-subnt" {
  vpc_id     = aws_vpc.tst-vpc.id
  cidr_block = "10.0.0.0/25"
  availability_zone = "us-west-2a"
  tags = {
      Name = "${var.environmentName}-aws-subnt-tst"

  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tst-vpc.id

  tags = {
    Name = "main"
  }
}


resource "aws_route_table" "example" {
  vpc_id = aws_vpc.tst-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.tat-subnt.id
  route_table_id = aws_route_table.example.id
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.tst-vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_instance" "web" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id              = aws_subnet.tat-subnt.id
  associate_public_ip_address = true
  key_name = "ravi-kp"
  user_data = file("bootstrap.tpl")
  iam_instance_profile = "ec2-read-s3"

  tags = {
    Name = "HelloWorld"
  }
}
resource "aws_vpc" "project1-VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "project1-VPC"
  }
}

########AZ1########################################
resource "aws_subnet" "pri_subnet1_az1" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "pri_subnet2_az1" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "pri_subnet3_az1" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "pub_subnet1_az1" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"
}

###########AZ2#######################################

resource "aws_subnet" "pri_subnet1_az2" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "pri_subnet2_az2" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "pri_subnet3_az2" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "pub_subnet1_az2" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1b"
}

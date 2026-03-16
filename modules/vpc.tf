resource "aws_vpc" "project1-VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "project1-VPC"
  }
}

########AZ1-subnet########################################
resource "aws_subnet" "pri_frontend_az1" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pri-frontend-az1"
  }
}

resource "aws_subnet" "pri_backend_az1" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pri-backend-az1"
  }
}

resource "aws_subnet" "pri_database_az1" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pri-database-az1"
  }
}

resource "aws_subnet" "alb_subnet1_az1" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "alb-subnet1-az1"
  }
}

###########AZ2-subnet#######################################

resource "aws_subnet" "pri_frontend_az2" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "pri-frontend-az2"
  }
}

resource "aws_subnet" "pri_backend_az2" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "pri-backend-az2"
  }
}

resource "aws_subnet" "pri_database_az2" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "pri-database-az2"
  }
}

resource "aws_subnet" "alb_subnet1_az2" {
  vpc_id            = aws_vpc.project1-VPC.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "alb-subnet1-az2"
  }
}

#################routing_table##############################
resource "aws_route_table" "alb-rt" {
  vpc_id = aws_vpc.project1-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project1-ig.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}


resource "aws_route_table" "private-rt-az1" {
  vpc_id = aws_vpc.project1-VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project1-nat-gw-az1.id
  }

  tags = {
    Name = "Private-Route-Table-az1"
  }
}


resource "aws_route_table" "private-rt-az2" {
  vpc_id = aws_vpc.project1-VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project1-nat-gw-az2.id
  }

  tags = {
    Name = "Private-Route-Table-az2"
  }
}



################NAT-ElasticIP################################
resource "aws_eip" "nat-eip-az1" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.project1-ig] //create ig first than elastic ip

  tags = {
    Name = "nat-eip-az1"
  }
}
resource "aws_eip" "nat-eip-az2" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.project1-ig]

  tags = {
    Name = "nat-eip-az2"
  }
}


################Internet-Gateway################################
resource "aws_internet_gateway" "project1-ig" {
  vpc_id = aws_vpc.project1-VPC.id

  tags = {
    Name = "main-igw"
  }
}


################NAT-Gateway################################
resource "aws_nat_gateway" "project1-nat-gw-az1" {
  allocation_id = aws_eip.nat-eip-az1.id
  subnet_id     = aws_subnet.alb_subnet1_az1.id
  depends_on    = [aws_internet_gateway.project1-ig]

  tags = {
    Name = "nat-gw-az1"
  }
}
resource "aws_nat_gateway" "project1-nat-gw-az2" {
  allocation_id = aws_eip.nat-eip-az2.id
  subnet_id     = aws_subnet.alb_subnet1_az2.id
  depends_on    = [aws_internet_gateway.project1-ig]

  tags = {
    Name = "nat-gw-az2"
  }
}


###############route-table-association################################
##Cannot use list for route table association

resource "aws_route_table_association" "public-assoc-az1" {
  subnet_id      = aws_subnet.alb_subnet1_az1.id
  route_table_id = aws_route_table.alb-rt.id
}
resource "aws_route_table_association" "frontend-assoc-az1" {
  subnet_id      = aws_subnet.pri_frontend_az1.id
  route_table_id = aws_route_table.private-rt-az1.id
}
resource "aws_route_table_association" "backend-assoc-az1" {
  subnet_id      = aws_subnet.pri_backend_az1.id
  route_table_id = aws_route_table.private-rt-az1.id
}
resource "aws_route_table_association" "database-assoc-az1" {
  subnet_id      = aws_subnet.pri_database_az1.id
  route_table_id = aws_route_table.private-rt-az1.id
}




resource "aws_route_table_association" "public-assoc-az2" {
  subnet_id      = aws_subnet.alb_subnet1_az2.id
  route_table_id = aws_route_table.alb-rt.id
}

resource "aws_route_table_association" "frontend-assoc-az2" {
  subnet_id      = aws_subnet.pri_frontend_az2.id
  route_table_id = aws_route_table.private-rt-az2.id
}
resource "aws_route_table_association" "backend-assoc-az2" {
  subnet_id      = aws_subnet.pri_backend_az2.id
  route_table_id = aws_route_table.private-rt-az2.id
}
resource "aws_route_table_association" "database-assoc-az2" {
  subnet_id      = aws_subnet.pri_database_az2.id
  route_table_id = aws_route_table.private-rt-az2.id
}


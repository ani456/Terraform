## Issues with overlapping CIDRs:

## VPC Peering: Not allowed between VPCs with overlapping CIDRs.
## Transit Gateway: Routing won't work properly with overlapping address spaces.
## VPN/Direct Connect: Can create routing conflicts.
## Private service communication: Becomes difficult or impossible without NAT or address translation.


resource "aws_vpc" "poneglyph1-vpc" {
  cidr_block = "10.1.0.0/16"

  #Disabling enable_dns_support and enable_dns_hostnames does not prevent resources in the same VPC from communicating via IP addresses.
  #However, hostname resolution stops working, which breaks communication that depends on DNS names, 
  #including many AWS managed services such as RDS, EFS, EKS, and internal load balancers

  enable_dns_support   = true
  enable_dns_hostnames = true

  assign_generated_ipv6_cidr_block = true ##apt used ipv6 address space for the VPC, which allows instances to have IPv6 addresses in addition to their IPv4 addresses.
  ## This is useful for applications that require global reachability or need to communicate with IPv6-only clients.


  tags = {
    Name = "poneglyph1-vpc"
  }

}



#public subnets for load balancer, NAT gateway, and bastion host#######################
resource "aws_subnet" "public-subnet1" {
  vpc_id                          = aws_vpc.poneglyph1-vpc.id
  cidr_block                      = "10.1.1.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.poneglyph1-vpc.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = true
  availability_zone               = "us-east-2a"

  tags = {
    Name = "public-subnet1"
  }

}

resource "aws_subnet" "public-subnet2" {
  vpc_id                          = aws_vpc.poneglyph1-vpc.id
  cidr_block                      = "10.1.3.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.poneglyph1-vpc.ipv6_cidr_block, 8, 3)
  assign_ipv6_address_on_creation = true
  availability_zone               = "us-east-2b"
  map_public_ip_on_launch         = true

  tags = {
    Name = "public-subnet2"
  }
}


#private subnets for instances and RDS############################################
resource "aws_subnet" "private-subnet-instance1" {
  vpc_id                          = aws_vpc.poneglyph1-vpc.id
  cidr_block                      = "10.1.4.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.poneglyph1-vpc.ipv6_cidr_block, 8, 5)
  assign_ipv6_address_on_creation = true
  availability_zone               = "us-east-2a"

  tags = {
    Name = "private-subnet-instance1"
  }
}
resource "aws_subnet" "private-subnet-instance2" {
  vpc_id            = aws_vpc.poneglyph1-vpc.id
  cidr_block        = "10.1.5.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "private-subnet-instance2"
  }
}
resource "aws_subnet" "private-subnet-rds1" {
  vpc_id                          = aws_vpc.poneglyph1-vpc.id
  cidr_block                      = "10.1.6.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.poneglyph1-vpc.ipv6_cidr_block, 8, 7)
  assign_ipv6_address_on_creation = true
  availability_zone               = "us-east-2a"

  tags = {
    Name = "private-subnet-rds1"
  }
}
resource "aws_subnet" "private-subnet-rds2" {
  vpc_id            = aws_vpc.poneglyph1-vpc.id
  cidr_block        = "10.1.7.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "private-subnet-rds2"
  }
}

#Elatic IP for NAT Gateway #####################################################################
resource "aws_eip" "poneglyph1-nat-eip1" {
  domain = "vpc"

  tags = {
    Name = "poneglyph1-nat-eip1"
  }
}

resource "aws_eip" "poneglyph1-nat-eip2" {
  domain = "vpc"

  tags = {
    Name = "poneglyph1-nat-eip2"
  }
}

#Nat Gateway #####################################################################

resource "aws_nat_gateway" "poneglyph1-nat-gateway-1" {
  subnet_id     = aws_subnet.public-subnet1.id
  allocation_id = aws_eip.poneglyph1-nat-eip1.id

  depends_on = [aws_internet_gateway.poneglyph1-igw]

  tags = {
    Name = "poneglyph1-nat-gateway-1"
  }
}

resource "aws_nat_gateway" "poneglyph1-nat-gateway-2" {
  subnet_id     = aws_subnet.public-subnet2.id
  allocation_id = aws_eip.poneglyph1-nat-eip2.id

  depends_on = [aws_internet_gateway.poneglyph1-igw]

  tags = {
    Name = "poneglyph1-nat-gateway-2"
  }
}


#Internet Gateway #################################################################
resource "aws_internet_gateway" "poneglyph1-igw" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  tags = {
    Name = "poneglyph1-igw"
  }
}

#Route Tables #####################################################################
resource "aws_route_table" "poneglyph1-public-rt" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  route {
    ##Route all outbound traffic to the Internet Gateway
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.poneglyph1-igw.id
  }
  tags = {
    Name = "poneglyph1-public-rt"
  }
}

resource "aws_route_table" "poneglyph1-private-rt-az1" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  route {
    ##Route all outbound traffic to the NAT Gateway
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.poneglyph1-nat-gateway-1.id
  }
  tags = {
    Name = "poneglyph1-private-rt-az1"
  }
}

resource "aws_route_table" "poneglyph1-private-rt-az2" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  route {
    ##Route all outbound traffic to the NAT Gateway
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.poneglyph1-nat-gateway-2.id
  }
  tags = {
    Name = "poneglyph1-private-rt-az2"
  }
}

resource "aws_route_table" "poneglyph1-private-rt-rds-az1" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  route {
    ##Route all outbound traffic to the NAT Gateway
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.poneglyph1-nat-gateway-1.id
  }
  tags = {
    Name = "poneglyph1-private-rt-rds-az1"
  }
}

resource "aws_route_table" "poneglyph1-private-rt-rds-az2" {
  vpc_id = aws_vpc.poneglyph1-vpc.id
  route {
    ##Route all outbound traffic to the NAT Gateway
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.poneglyph1-nat-gateway-2.id
  }
  tags = {
    Name = "poneglyph1-private-rt-rds-az2"
  }
}


#Route Table Associations #####################################################################
resource "aws_route_table_association" "public-subnet1-association" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.poneglyph1-public-rt.id
}
resource "aws_route_table_association" "public-subnet2-association" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.poneglyph1-public-rt.id
}

resource "aws_route_table_association" "private-subnet-instance1-association" {
  subnet_id      = aws_subnet.private-subnet-instance1.id
  route_table_id = aws_route_table.poneglyph1-private-rt-az1.id
}
resource "aws_route_table_association" "private-subnet-instance2-association" {
  subnet_id      = aws_subnet.private-subnet-instance2.id
  route_table_id = aws_route_table.poneglyph1-private-rt-az2.id
}

resource "aws_route_table_association" "private-subnet-rds1-association" {
  subnet_id      = aws_subnet.private-subnet-rds1.id
  route_table_id = aws_route_table.poneglyph1-private-rt-rds-az1.id
}
resource "aws_route_table_association" "private-subnet-rds2-association" {
  subnet_id      = aws_subnet.private-subnet-rds2.id
  route_table_id = aws_route_table.poneglyph1-private-rt-rds-az2.id
}


#

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "172.16.0.0/16"
    gateway_id = aws_internet_gateway.main_internet_gw.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "172.16.0.0/16"
    gateway_id = aws_internet_gateway.main_internet_gw.id
  }

}

resource "aws_internet_gateway" "main_internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gw"
  }

}

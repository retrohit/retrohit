resource "aws_route_table" "retrohit_rt" {
  vpc_id = aws_vpc.retrohit_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.retrohit_igw.id
  }

  tags = {
    Name = "retrohit-rt"
  }
}

resource "aws_route_table_association" "retrohit_rta" {
  subnet_id      = aws_subnet.retrohit_subnet.id
  route_table_id = aws_route_table.retrohit_rt.id
}

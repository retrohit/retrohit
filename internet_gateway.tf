resource "aws_internet_gateway" "retrohit_igw" {
  vpc_id = aws_vpc.retrohit_vpc.id

  tags = {
    Name = "retrohit-igw"
  }
}

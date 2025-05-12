resource "aws_subnet" "retrohit_subnet" {
  vpc_id            = aws_vpc.retrohit_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "retrohit-subnet"
  }
}

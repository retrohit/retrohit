resource "aws_vpc" "retrohit_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "retrohit-vpc"
  }
}

# public subnet
resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"

  availability_zone_id = "use1-az1"

  tags = {
    Name = "public-subnet"
  }

  map_public_ip_on_launch = true
}

# private subnet
resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone_id = "use1-az2"

  tags = {
    Name = "private-subnet"
  }
}
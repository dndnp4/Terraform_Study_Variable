resource "aws_internet_gateway" "devjs_igw" {
  vpc_id = aws_vpc.devjs_vpc.id

  tags = {
    "Name" = "${var.name_prefix}_igw"
  }
}

resource "aws_route_table" "devjs_public_rt" {
  vpc_id = aws_vpc.devjs_vpc.id

  route {
    cidr_block = var.cidr_all
    gateway_id = aws_internet_gateway.devjs_igw.id
  }

  tags = {
    "Name" = "${var.name_prefix}_public_rt"
  }
}

resource "aws_route_table_association" "devjs_public_rt_assoc" {
  count          = length(var.cidr_public_subnets)
  subnet_id      = aws_subnet.devjs_public_subnets[count.index].id
  route_table_id = aws_route_table.devjs_public_rt.id
}

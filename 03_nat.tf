resource "aws_eip" "devjs_eip_nat" {
  vpc = true
}

resource "aws_nat_gateway" "devjs_nat" {
  allocation_id = aws_eip.devjs_eip_nat.id
  subnet_id     = aws_subnet.devjs_public_subnets[0].id
  tags = {
    "Name" = "${var.name_prefix}_nat"
  }
  depends_on = [
    aws_internet_gateway.devjs_igw
  ]
}

resource "aws_route_table" "devjs_private_rt" {
  vpc_id = aws_vpc.devjs_vpc.id
  route {
    cidr_block = var.cidr_all
    gateway_id = aws_nat_gateway.devjs_nat.id
  }

  tags = {
    "Name" = "${var.name_prefix}_private_rt"
  }
}

resource "aws_route_table_association" "devjs_private_rt_assoc" {
  count          = length(var.cidr_private_subnets)
  subnet_id      = aws_subnet.devjs_private_subnets[count.index].id
  route_table_id = aws_route_table.devjs_private_rt.id
}

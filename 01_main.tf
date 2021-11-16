provider "aws" {
  region = var.region
}

resource "aws_key_pair" "devjs_key" {
  key_name   = var.common_ssh_key.name
  public_key = file(var.common_ssh_key.path)
}

resource "aws_vpc" "devjs_vpc" {
  cidr_block = var.cidr_vpc
  tags = {
    "Name" = "${var.name_prefix}_vpc"
  }
}

resource "aws_subnet" "devjs_public_subnets" {
  count             = length(var.az)
  vpc_id            = aws_vpc.devjs_vpc.id
  cidr_block        = var.cidr_public_subnets[count.index]
  availability_zone = "${var.region}${var.az[count.index]}"

  tags = {
    "Name" = "${var.name_prefix}_public_subnet_${var.az[count.index]}"
  }
}

resource "aws_subnet" "devjs_private_subnets" {
  count             = length(var.az)
  vpc_id            = aws_vpc.devjs_vpc.id
  cidr_block        = var.cidr_private_subnets[count.index]
  availability_zone = "${var.region}${var.az[count.index]}"

  tags = {
    "Name" = "${var.name_prefix}_private_subnet_${var.az[count.index]}"
  }
}

resource "aws_subnet" "devjs_private_db_subnets" {
  count             = length(var.az)
  vpc_id            = aws_vpc.devjs_vpc.id
  cidr_block        = var.cidr_private_db_subnets[count.index]
  availability_zone = "${var.region}${var.az[count.index]}"

  tags = {
    "Name" = "${var.name_prefix}_private_db_subnet_${var.az[count.index]}"
  }
}

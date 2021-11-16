resource "aws_db_instance" "devjs_rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  name                   = "test"
  identifier             = "test"
  username               = "admin"
  password               = "wlstjd11!"
  parameter_group_name   = "default.mysql8.0"
  availability_zone      = "${var.region}${var.az[0]}"
  vpc_security_group_ids = [aws_security_group.devjs_sg.id]
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.devjs_dbsb.id
  tags = {
    "Name" = "${var.name_prefix}_rds"
  }
}

resource "aws_db_subnet_group" "devjs_dbsb" {
  name       = "${var.name_prefix}-dbsb"
  subnet_ids = aws_subnet.devjs_public_subnets[*].id
  tags = {
    "Name" = "${var.name_prefix}_dbsb"
  }
}

resource "aws_instance" "devjs_webserver_sample" {
  ami                    = var.ec2_webserver_options.ami
  instance_type          = var.ec2_webserver_options.instance_type
  key_name               = aws_key_pair.devjs_key.key_name
  availability_zone      = "${var.region}${var.az[0]}"
  private_ip             = var.ec2_webserver_options.sample_private_ip
  subnet_id              = aws_subnet.devjs_public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.devjs_sg.id]
  user_data              = file(var.ec2_webserver_options.user_data_path)
}

resource "aws_eip" "devjs_eip_webserver_sample" {
  vpc                       = true
  instance                  = aws_instance.devjs_webserver_sample.id
  associate_with_private_ip = var.ec2_webserver_options.sample_private_ip
  depends_on = [
    aws_internet_gateway.devjs_igw
  ]
}

resource "aws_security_group" "devjs_sg" {
  name   = "AllowAll"
  vpc_id = aws_vpc.devjs_vpc.id
  # ingress = [
  #   {
  #     description      = "Allow HTTP"
  #     from_port        = 80
  #     to_port          = 80
  #     protocol         = "tcp"
  #     cidr_blocks      = [var.cidr_all]
  #     ipv6_cidr_blocks = ["::/0"]
  #     security_groups  = null
  #     prefix_list_ids  = null
  #     self             = null
  #   },
  #   {
  #     description      = "Allow SSH"
  #     from_port        = 22
  #     to_port          = 22
  #     protocol         = "tcp"
  #     cidr_blocks      = [var.cidr_all]
  #     ipv6_cidr_blocks = ["::/0"]
  #     security_groups  = null
  #     prefix_list_ids  = null
  #     self             = null
  #   },
  #   {
  #     description      = "Allow SQL"
  #     from_port        = 3306
  #     to_port          = 3306
  #     protocol         = "tcp"
  #     cidr_blocks      = [var.cidr_all]
  #     ipv6_cidr_blocks = ["::/0"]
  #     security_groups  = null
  #     prefix_list_ids  = null
  #     self             = null
  #   },
  #   {
  #     description      = "Allow ICMP"
  #     from_port        = 0
  #     to_port          = 0
  #     protocol         = "icmp"
  #     cidr_blocks      = [var.cidr_all]
  #     ipv6_cidr_blocks = ["::/0"]
  #     security_groups  = null
  #     prefix_list_ids  = null
  #     self             = null
  #   }
  # ]
  # egress = [
  #   {
  #     description      = "Allow All"
  #     from_port        = 0
  #     to_port          = 0
  #     protocol         = -1
  #     cidr_blocks      = [var.cidr_all]
  #     ipv6_cidr_blocks = ["::/0"]
  #     security_groups  = null
  #     prefix_list_ids  = null
  #     self             = null
  #   }
  # ]
  tags = {
    "Name" = "${var.name_prefix}_sg"
  }
}

resource "aws_security_group_rule" "default_ingress_http" {
  type              = "ingress"
  description       = "Allow HTTP"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_all]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.devjs_sg.id
  prefix_list_ids   = null
  self              = null
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "default_ingress_ssh" {
  type              = "ingress"
  description       = "Allow SSH"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_all]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.devjs_sg.id
  prefix_list_ids   = null
  self              = null
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "default_ingress_sql" {
  type              = "ingress"
  description       = "Allow SQL"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_all]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.devjs_sg.id
  prefix_list_ids   = null
  self              = null
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "default_ingress_icmp" {
  type              = "ingress"
  description       = "Allow ICMP"
  from_port         = 0
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = [var.cidr_all]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.devjs_sg.id
  prefix_list_ids   = null
  self              = null
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "default_egress" {
  type              = "egress"
  description       = "Allow All"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = [var.cidr_all]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.devjs_sg.id
  prefix_list_ids   = null
  self              = null
  lifecycle { create_before_destroy = true }
}

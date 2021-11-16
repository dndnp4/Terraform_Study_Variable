resource "aws_lb" "devjs_alb" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.devjs_sg.id]
  subnets            = aws_subnet.devjs_public_subnets[*].id

  tags = {
    "Name" = "${var.name_prefix}_alb"
  }
}

resource "aws_lb_target_group" "devjs_alb_target_group" {
  name     = "${var.name_prefix}-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.devjs_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health.html"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "devjs_alb_listener" {
  load_balancer_arn = aws_lb.devjs_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devjs_alb_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "devjs_lb_atch" {
  target_group_arn = aws_lb_target_group.devjs_alb_target_group.arn
  target_id        = aws_instance.devjs_webserver_sample.id
  port             = 80
}


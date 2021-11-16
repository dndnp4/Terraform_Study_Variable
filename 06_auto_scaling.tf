resource "aws_ami_from_instance" "devjs_ami" {
  name                    = "${var.name_prefix}-ami"
  source_instance_id      = aws_instance.devjs_webserver_sample.id
  snapshot_without_reboot = true

  tags = {
    "Name" = "${var.name_prefix}_ami"
  }
  depends_on = [
    aws_instance.devjs_webserver_sample
  ]
}

resource "aws_launch_configuration" "devjs_launch_configuration" {
  name_prefix          = "${var.name_prefix}-worpress-"
  image_id             = aws_ami_from_instance.devjs_ami.id
  instance_type        = var.ec2_webserver_options.instance_type
  iam_instance_profile = "admin_role"
  security_groups      = [aws_security_group.devjs_sg.id]
  key_name             = aws_key_pair.devjs_key.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_placement_group" "devjs_place" {
  name     = "${var.name_prefix}-place"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "devjs_autoscaling_group" {
  name                      = "${var.name_prefix}-autoscaling-group"
  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  health_check_grace_period = 10
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.devjs_launch_configuration.name
  vpc_zone_identifier       = aws_subnet.devjs_public_subnets[*].id
}

resource "aws_autoscaling_attachment" "devjs_autoscaling_atch" {
  autoscaling_group_name = aws_autoscaling_group.devjs_autoscaling_group.id
  alb_target_group_arn   = aws_lb_target_group.devjs_alb_target_group.arn
}

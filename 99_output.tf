output "webserver_sample_eip" {
  value = aws_eip.devjs_eip_webserver_sample.public_ip
}

output "alb_dns" {
  value = aws_lb.devjs_alb.dns_name
}
output "test" {
  value = aws_subnet.devjs_public_subnets[*].id
}
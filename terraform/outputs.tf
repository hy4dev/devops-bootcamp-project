output "web_server_eip" {
  description = "EIP of the web server"
  value       = module.web_server.public_ip
}

output "web_server_private_ip" {
  value = module.web_server.private_ip
}

output "ssm_command_to_web_server" {
  value = "aws ssm start-session --target ${module.web_server.id}"
}

output "controller_server_private_ip" {
  value = module.controller_server.private_ip
}

output "ssm_command_to_controller_server" {
  value = "aws ssm start-session --target ${module.controller_server.id}"
}

output "monitoring_server_private_ip" {
  value = module.monitoring_server.private_ip
}

output "ssm_command_to_monitoring_server" {
  value = "aws ssm start-session --target ${module.monitoring_server.id}"
}

output "nat_gateway_public_eip" {
  description = "EIP of the NAT gateway"
  value       = aws_nat_gateway.devops_ngw.public_ip
}
# -----------------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID of the DevOps VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the DevOps VPC"
  value       = module.vpc.vpc_cidr_block
}

# -----------------------------------------------------------------------------
# Subnets
# -----------------------------------------------------------------------------

output "public_subnet_id" {
  description = "ID of the DevOps public subnet"
  value       = module.vpc.public_subnets[0]
}

output "private_subnet_id" {
  description = "ID of the DevOps private subnet"
  value       = module.vpc.private_subnets[0]
}

# -----------------------------------------------------------------------------
# Route Tables
# -----------------------------------------------------------------------------

output "public_route_table_id" {
  description = "ID of the DevOps public route table"
  value       = module.vpc.public_route_table_ids[0]
}

output "private_route_table_id" {
  description = "ID of the DevOps private route table"
  value       = module.vpc.private_route_table_ids[0]
}

# -----------------------------------------------------------------------------
# Internet Gateway
# -----------------------------------------------------------------------------

output "internet_gateway_id" {
  description = "ID of the DevOps Internet Gateway"
  value       = module.vpc.igw_id
}

# -----------------------------------------------------------------------------
# NAT Gateway
# -----------------------------------------------------------------------------

output "nat_gateway_id" {
  description = "ID of the DevOps NAT Gateway"
  value       = module.vpc.natgw_ids[0]
}

output "nat_gateway_public_ip" {
  description = "Public EIP of the NAT Gateway"
  value       = module.vpc.nat_public_ips[0]
}

# -----------------------------------------------------------------------------
# Security Groups
# -----------------------------------------------------------------------------

output "public_security_group_id" {
  description = "ID of the public security group"
  value       = module.public_sg.id
}

output "private_security_group_id" {
  description = "ID of the private security group"
  value       = module.private_sg.id
}

# -----------------------------------------------------------------------------
# Web Server
# -----------------------------------------------------------------------------

output "web_server_id" {
  description = "Web server EC2 instance ID"
  value       = module.web_server.id
}

output "web_server_private_ip" {
  description = "Web server private IP"
  value       = module.web_server.private_ip
}

output "web_server_public_ip" {
  description = "Web server Elastic IP"
  value       = module.web_server.public_ip
}

# -----------------------------------------------------------------------------
# Controller Server
# -----------------------------------------------------------------------------

output "controller_server_id" {
  description = "Controller server EC2 instance ID"
  value       = module.controller_server.id
}

output "controller_server_private_ip" {
  description = "Controller server private IP"
  value       = module.controller_server.private_ip
}

# -----------------------------------------------------------------------------
# Monitoring Server
# -----------------------------------------------------------------------------

output "monitoring_server_id" {
  description = "Monitoring server EC2 instance ID"
  value       = module.monitoring_server.id
}

output "monitoring_server_private_ip" {
  description = "Monitoring server private IP"
  value       = module.monitoring_server.private_ip
}
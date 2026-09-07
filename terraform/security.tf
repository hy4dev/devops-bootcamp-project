# Note: SSH connection is added to the ingress rule but as per requirement, only SSM is used.
# To use SSH, ec2.tf must be modified by adding "key_name" to every AMI.  

###########################################################
# Public Security Group
###########################################################

module "devops_public_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name            = "devops-public-sg"
  use_name_prefix = false
  vpc_id          = aws_vpc.devops_vpc.id

  ingress_rules = {
    http = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
    }

    node_exporter = {
      cidr_ipv4   = "10.0.0.136/32"
      ip_protocol = "tcp"
      from_port   = 9100
      to_port     = 9100
    }

    ssh = {
      description = "SSH from subnet VPC"
      cidr_ipv4   = "10.0.0.128/25"
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
    }

  }

  egress_rules = {
    all = { cidr_ipv4 = "0.0.0.0/0", ip_protocol = "-1" }
  }

  tags = { Name = "devops-public-sg" }
}

###########################################################
# Private Security Group
###########################################################

module "devops_private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name            = "devops-private-sg"
  use_name_prefix = false
  vpc_id          = aws_vpc.devops_vpc.id

  ingress_rules = {
    ssh = {
      description = "SSH from public subnet"
      cidr_ipv4   = "10.0.0.0/25"
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
    }

  }

  egress_rules = {
    all = { cidr_ipv4 = "0.0.0.0/0", ip_protocol = "-1" }
  }

  tags = { Name = "devops-private-sg" }
}
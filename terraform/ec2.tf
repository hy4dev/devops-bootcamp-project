###########################################################
# AMI and SSM
###########################################################

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "EC2-SSM-Role"
}

data "aws_ssm_parameter" "token" {
  name = "/devops-bootcamp-project/tunnel-token"
}

###########################################################
# Web Server
###########################################################

module "web_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                        = "devops-web-server"
  ami                         = data.aws_ami.ami.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.devops_public_subnet.id
  private_ip                  = "10.0.0.5"
  associate_public_ip_address = false
  create_eip                  = true
  create_security_group       = false
  vpc_security_group_ids      = [module.devops_public_sg.id]
  iam_instance_profile        = data.aws_iam_instance_profile.ec2_ssm_profile.name

  #user_data = templatefile("userdata.sh", {})
  tags = {
    Name = "devops-web-server"
    Role = "web"
  }
}

###########################################################
# Controller Server
###########################################################

module "controller_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                        = "devops-controller-server"
  ami                         = data.aws_ami.ami.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.devops_private_subnet.id
  private_ip                  = "10.0.0.135"
  associate_public_ip_address = false
  create_security_group       = false
  vpc_security_group_ids      = [module.devops_private_sg.id]
  iam_instance_profile        = data.aws_iam_instance_profile.ec2_ssm_profile.name

  tags = {
    Name = "devops-controller-server"
    Role = "controller"
  }
}

###########################################################
# Monitoring Server
###########################################################

module "monitoring_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                        = "devops-monitoring-server"
  ami                         = data.aws_ami.ami.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.devops_private_subnet.id
  private_ip                  = "10.0.0.136"
  associate_public_ip_address = false
  create_security_group       = false
  vpc_security_group_ids      = [module.devops_private_sg.id]
  iam_instance_profile        = data.aws_iam_instance_profile.ec2_ssm_profile.name

  #user_data = templatefile("userdata-tunnel.sh", {
  #  tunnel_token = data.aws_ssm_parameter.token.value
  #})

  tags = {
    Name = "devops-monitoring-server"
    Role = "monitoring"
  }
}
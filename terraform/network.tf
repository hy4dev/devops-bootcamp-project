module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "devops-vpc"
  cidr = "10.0.0.0/24"
  azs  = ["ap-southeast-1a"]

  public_subnets       = ["10.0.0.0/25"]
  public_subnet_names  = ["devops-public-subnet"]
  public_subnet_suffix = "public-route"

  private_subnets       = ["10.0.0.128/25"]
  private_subnet_names  = ["devops-private-subnet"]
  private_subnet_suffix = "private-route"

  create_igw = true

  igw_tags = {
    Name = "devops-igw"
  }

  enable_nat_gateway = true
  single_nat_gateway = true

  nat_gateway_tags = {
    Name = "devops-ngw"
  }

  nat_eip_tags = {
    Name = "devops-ngw-eip"
  }

  map_public_ip_on_launch = true
  enable_dns_hostnames    = true
  enable_dns_support      = true

  tags = {
    Name = "devops-vpc"
  }
}
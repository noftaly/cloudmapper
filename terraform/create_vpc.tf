module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.1.0"

  name = var.account_prefix
  cidr = "10.20.0.0/16"

  enable_nat_gateway = true
  enable_vpn_gateway = false

  vpc_tags = {
    Name = "${var.account_prefix}-vpc"
  }

  # Setup the Subnets
  azs             = ["eu-west-3a", "eu-west-3b"]
  private_subnets = ["10.20.1.0/24"]
  public_subnets  = ["10.20.2.0/24", "10.20.3.0/24"]

  # Setup the Internet Gateway
  create_igw = true
  igw_tags = {
    Name = "${var.account_prefix}-igw"
  }
}

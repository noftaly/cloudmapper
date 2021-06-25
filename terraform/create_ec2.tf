data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

module "cloudmapper" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"

  name = "cloudmapper"

  user_data              = "${file("./boot.sh")}"
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.cloudmapper_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  iam_instance_profile   = module.cloudmapper_ssm_role.iam_instance_profile_name

  tags = {
    Name = "cloudmapper-instance"
  }
}

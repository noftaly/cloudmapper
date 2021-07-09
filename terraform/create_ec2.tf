data "template_file" "user_data" {
  template = "${file("./boot.sh")}"
  vars = {
    gitlab_auth = var.userdata_gitlab_auth
    cpk_tf_bot_access_key_id = var.userdata_cpk_tf_bot_access_key_id
    cpk_tf_bot_secret_access_key = var.userdata_cpk_tf_bot_secret_access_key
    target_role_arn = var.userdata_target_role_arn
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

module "cloudmapper_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"

  name           = "${var.account_prefix}-cloudmapper"
  instance_count = 2
  num_suffix_format = "-%d"
  use_num_suffix = true

  user_data              = data.template_file.user_data.rendered
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.cloudmapper_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]
  iam_instance_profile   = module.cloudmapper_ssm_role.iam_instance_profile_name

  tags = {
    Name = "${var.account_prefix}-cloudmapper-srv"
  }
}

module "cloudmapper_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.account_prefix}-sg"
  vpc_id = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      description = "All"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_with_cidr_blocks = [
    {
      description = "Web port 8000"
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = join(",", var.whitelisted_cidrs)
    }
  ]

  tags = {
    Name = "${var.account_prefix}-sg"
  }
}

module "cloudmapper_ssm_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  create_role             = true
  create_instance_profile = true

  role_name         = "${var.account_prefix}_ssm_role"
  role_requires_mfa = false

  trusted_role_services = ["ec2.amazonaws.com"]

  custom_role_policy_arns = [module.cloudmapper_ssm_policy.arn]
}

module "cloudmapper_ssm_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.1.0"

  name = "${var.account_prefix}-ssm"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeDocument",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ssmmessages:OpenControlChannel",
                "ssm:PutConfigurePackageResult",
                "ssm:ListInstanceAssociations",
                "ssm:GetParameter",
                "ssm:UpdateAssociationStatus",
                "ssm:GetManifest",
                "ec2messages:DeleteMessage",
                "ssm:UpdateInstanceInformation",
                "ec2messages:FailMessage",
                "ssmmessages:OpenDataChannel",
                "ssm:GetDocument",
                "ssm:PutComplianceItems",
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ec2messages:AcknowledgeMessage",
                "ssm:GetParameters",
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssm:PutInventory",
                "ec2messages:SendReply",
                "ssm:ListAssociations",
                "ssm:UpdateInstanceAssociationStatus"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

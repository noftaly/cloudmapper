module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name               = "${var.account_prefix}-alb"
  load_balancer_type = "application"
  internal           = false
  ip_address_type    = "ipv4"
  security_groups    = [module.alb_sg.security_group_id]

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      action_type        = "forward"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = "${var.account_prefix}-tg-cloudmapper"
      backend_port     = 8000
      backend_protocol = "HTTP"
      target_type      = "instance"
      targets          = [ for i in range(module.cloudmapper_instances.instance_count): { target_id = module.cloudmapper_instances.id[i], port = 8000 }]
      health_check = {
        healthy_threshold   = 3
        unhealthy_threshold = 2
        protocol            = "HTTP"
        matcher             = "200"
        path                = "/health.txt"
        port                = "traffic-port"
        interval            = 6
        timeout             = 5
      }
    }
  ]

  lb_tags = {
    Name = "${var.account_prefix}-alb"
  }
}

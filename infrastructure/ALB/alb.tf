resource "aws_lb" "this" {
  name               = "${var.project}-backend-${terraform.workspace}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids
  ip_address_type    = "ipv4"
  idle_timeout       = 120

  tags = {
    Project     = var.project
    Name        = "Load Balancer"
    Environment = terraform.workspace
  }
}

resource "aws_lb_target_group" "this" {
  name                 = "${var.project}-backend-${terraform.workspace}"
  port                 = 8000
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10
  depends_on = [
    aws_lb.this,
  ]

  health_check {
    path = "/health-check/"
  }

  tags = {
    Project     = var.project
    Name        = "Target Group"
    Environment = terraform.workspace
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
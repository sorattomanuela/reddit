locals {
  default_name = "${var.project}-backend-${terraform.workspace}"
}

# Docker image repository
resource "aws_ecr_repository" "ecr" {
  name = local.default_name

  tags = {
    Project     = var.project
    Name        = "ECR Repository"
    Environment = terraform.workspace
  }
}

resource "aws_cloudwatch_log_group" "this_log" {
  name              = local.default_name
  retention_in_days = var.log_retention

  tags = {
    Project     = var.project
    Name        = "Cloudwatch"
    Environment = terraform.workspace
  }
}

resource "aws_ecs_task_definition" "this" {
  family = local.default_name
  container_definitions = templatefile("${path.module}/task_definition_template.json",
    { name      = "backend"
      image     = "${aws_ecr_repository.ecr.repository_url}:${terraform.workspace}"
      env       = terraform.workspace
      log_group = aws_cloudwatch_log_group.this_log.name
      region    = var.region
    }
  )

  tags = {
    Project     = var.project
    Name        = "ECS Task Definition"
    Environment = terraform.workspace
  }
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${local.default_name}-cluster"

  tags = {
    Project     = var.project
    Name        = "Cluster"
    Environment = terraform.workspace
  }
}

# EC2 instance role and policies
resource "aws_iam_role" "ecs-instance-role" {
  name               = "${local.default_name}-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json

  tags = {
    Project     = var.project
    Name        = "EC2 instance role and policies"
    Environment = terraform.workspace
  }
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment-S3-full-access" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs-instance-role.id
}

resource "aws_launch_configuration" "this" {
  name_prefix          = local.default_name
  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = var.instance_type
  security_groups      = var.security_group_ids
  key_name             = var.key_name
  user_data            = "#!/bin/bash\necho ECS_CLUSTER='${aws_ecs_cluster.this.name}' > /etc/ecs/ecs.config"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                 = local.default_name
  max_size             = var.max_instances
  min_size             = var.min_instances
  desired_capacity     = var.desired_instances
  vpc_zone_identifier  = var.subnet_ids
  launch_configuration = aws_launch_configuration.this.name
  health_check_type    = "ELB"

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Project"
      value               = var.project
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${var.project} backend ${terraform.workspace}"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = terraform.workspace
      propagate_at_launch = true
    },
  ]
}

resource "aws_ecs_service" "this" {
  name                               = local.default_name
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.desired_service_tasks
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "backend"
    container_port   = 8000
  }
}

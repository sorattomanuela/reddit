data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "elb_security_group" {
  vpc_id      = data.aws_vpc.default.id
  name        = "${var.project}-backend-${terraform.workspace}-elb"
  description = "Security Group for ELB on ${var.project} Backend ${terraform.workspace}"
  tags = {
    Project     = var.project
    Name        = "Security Group"
    Environment = terraform.workspace
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instances_security_group" {
  vpc_id      = data.aws_vpc.default.id
  name        = "${var.project}-backend-${terraform.workspace}-instances"
  description = "Security Group for Instances on ${var.project} Backend ${terraform.workspace}"
  tags = {
    Project     = var.project
    Name        = "Security Group"
    Environment = terraform.workspace
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.elb_security_group.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["189.90.55.146/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_security_group" {
  vpc_id      = data.aws_vpc.default.id
  name        = "${var.project}-backend-${terraform.workspace}-rds"
  description = "Security Group for RDS on ${var.project} Backend ${terraform.workspace}"
  tags = {
    Project     = var.project
    Name        = "Security Group"
    Environment = terraform.workspace
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.instances_security_group.id]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["189.90.55.146/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

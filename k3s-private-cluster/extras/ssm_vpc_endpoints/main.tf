terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "ssm_sg" {
  name        = "session-manager"
  vpc_id      = data.aws_vpc.this.id
  description = "Allow EC2 to communicate with System Manager (SSM)"

  ingress {
    description = "Allow VPC endpoints (defined below) to be reachable by EC2 instances"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    description = "Allow All Egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc_endpoint_service" "ssm" {
  service = "ssm"
}

data "aws_vpc_endpoint_service" "ssmmessages" {
  service = "ssmmessages"
}

data "aws_vpc_endpoint_service" "ec2messages" {
  service = "ec2messages"
}


resource "aws_vpc_endpoint" "ssm" {
  vpc_endpoint_type   = "Interface"
  vpc_id              = data.aws_vpc.this.id
  subnet_ids          = local.private_subnets
  service_name        = data.aws_vpc_endpoint_service.ssm.service_name
  private_dns_enabled = true # resolve to private ip for service
  security_group_ids  = [aws_security_group.ssm_sg.id]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_endpoint_type   = "Interface"
  vpc_id              = data.aws_vpc.this.id
  subnet_ids          = local.private_subnets
  service_name        = data.aws_vpc_endpoint_service.ssmmessages.service_name
  private_dns_enabled = true # resolve to private ip for service
  security_group_ids  = [aws_security_group.ssm_sg.id]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_endpoint_type   = "Interface"
  vpc_id              = data.aws_vpc.this.id
  subnet_ids          = local.private_subnets
  service_name        = data.aws_vpc_endpoint_service.ec2messages.service_name
  private_dns_enabled = true # private ip for service
  security_group_ids  = [aws_security_group.ssm_sg.id]
}

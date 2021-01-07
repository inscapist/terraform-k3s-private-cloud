terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

module "k3s_master" {
  # Functions as:
  # - kubernetes API server
  # - kubernetes control plane (kube-system)
  # - jump host (via System Manager's Session Manager)
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "k3s-master-${var.cluster_name}"
  instance_count = 1

  ami                         = data.aws_ami.ubuntu_focal.id
  instance_type               = var.master_instance_type
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = ["${module.sg.this_security_group_id}"]
  subnet_id                   = module.vpc.public_subnets[0]
  user_data                   = local.master_userdata
  iam_instance_profile        = aws_iam_instance_profile.k3s_master_profile.id
  associate_public_ip_address = true

  tags = {
    KubernetesCluster = var.cluster_name
  }
}

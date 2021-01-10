provider "aws" {
  region  = "ap-southeast-1" # change this
  profile = "default"        # can be changed to other profile
}

module "k3s-in-existing-vpc" {
  source               = "../.."
  cluster_name         = "k3s-in-existing-vpc" # change this
  vpc_id               = "vpc-35504650"        # change this
  master_instance_type = "m6g.medium"
}

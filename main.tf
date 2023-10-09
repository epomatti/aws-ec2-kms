terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  workload = "mipo"
}

module "network" {
  source   = "./modules/network"
  workload = local.workload
  region   = var.aws_region
}

module "iam_a" {
  source   = "./modules/iam/ec2rolea"
  workload = local.workload
}

module "iam_b" {
  source   = "./modules/iam/ec2roleb"
  workload = local.workload
}

module "kms" {
  source    = "./modules/kms"
  rolea_arn = module.iam_a.role_arn
  roleb_arn = module.iam_b.role_arn
}

module "ec2a" {
  source              = "./modules/ec2"
  workload            = local.workload
  server_name         = "EC2A"
  instance_profile_id = module.iam_a.instance_profile_id
  vpc_id              = module.network.vpc_id
  subnet              = module.network.public_subnets[0]
}

module "ec2b" {
  source              = "./modules/ec2"
  workload            = local.workload
  server_name         = "EC2B"
  instance_profile_id = module.iam_b.instance_profile_id
  vpc_id              = module.network.vpc_id
  subnet              = module.network.public_subnets[0]
}

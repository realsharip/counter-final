
module "eks_vpc" {
  source               = "./modules/vpc"
  region               = var.region
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_classiclink   = var.enable_classiclink
  vpc_cidr_block       = var.vpc_cidr_block
  pub_sub_cidr         = var.pub_sub_cidr
  priv_sub_cidr        = var.priv_sub_cidr
}

/* module "security_group" {
  source = "./modules/security_groups"
  ports  = var.ports
  vpc_id = module.eks_vpc.vpc_id
} */

module "eks" {
  source       = "./modules/eks"
  subnet_ids   = module.eks_vpc.subnet_ids
  vpc_id       = module.eks_vpc.vpc_id
  cluster_role = var.cluster_role
  cluster_name = var.cluster_name
}

module "eks_nodes" {
  source                                = "./modules/eks_nodes"
  instance_type                         = var.instance_type
  desired_capacity                      = var.desired_capacity
  min_size                              = var.min_size
  max_size                              = var.max_size
  eks_version                           = var.eks_version
  cluster_name                          = var.cluster_name
  source_security_group_id              = module.eks.aws_security_group_master
  vpc_id                                = module.eks_vpc.vpc_id
  pub_sub_cidr                          = module.eks_vpc.pub_subnet_ids
  aws_eks_cluster_endpoint              = module.eks.endpoint
  aws_eks_cluster_certificate_authority = module.eks.kubeconfig-certificate-authority-data
}

module "cm" {
  source          = "./modules/cm"
  eks_wn_role_arn = module.eks_nodes.wn_arn
}
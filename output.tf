output "vpc_id" {
  value = module.eks_vpc.vpc_id
}

output "subnet_ids" {
  value = module.eks_vpc.subnet_ids
}

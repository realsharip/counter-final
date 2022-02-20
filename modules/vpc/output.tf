output "vpc_id" {
  value       = aws_vpc.vpc_eks.id
  description = "The ID of VPC-EKS."
}

output "pub_sub_1" {
  value = aws_subnet.pub_eks_1.id
  description = "First public subnet ID"
}

output "pub_sub_2" {
  value = aws_subnet.pub_eks_2.id
  description = "Second public subnet ID"
}

output "priv_sub_1" {
  value = aws_subnet.priv_eks_1.id
  description = "First private subnet ID"
}

output "priv_sub_2" {
  value = aws_subnet.priv_eks_2.id
  description = "Second private subnet ID"
}

output "subnet_ids" {
  value = concat([aws_subnet.pub_eks_1.id, aws_subnet.pub_eks_2.id, aws_subnet.priv_eks_1.id, aws_subnet.priv_eks_2.id])
}

output "pub_subnet_ids" {
  value = concat([aws_subnet.pub_eks_1.id, aws_subnet.pub_eks_2.id])
}

output "priv_subnet_ids" {
  value = concat([aws_subnet.priv_eks_1.id, aws_subnet.priv_eks_2.id])
}
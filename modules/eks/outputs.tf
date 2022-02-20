output "endpoint" {
  value = aws_eks_cluster.realeks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.realeks.certificate_authority[0].data
}

output "aws_security_group_master" {
  value = aws_security_group.master.id
}
output "sg_id" {
  value       = aws_security_group.sg_eks.id
  description = "ID of EKS security group"
}

# -----------------------------------------------------------------------------
# Required input variables
# -----------------------------------------------------------------------------
variable "cluster_name" {
  type        = string
  description = "(Required) The name of the Amazon EKS cluster."
}

variable "instance_type" {
  type        = string
  description = "(Required) The EC2 instance type to use for the worker nodes."
}

variable "desired_capacity" {
  type        = number
  description = "(Required) The desired number of nodes to create in the node group."
}

variable "min_size" {
  type        = number
  description = "(Required) The minimum number of nodes to create in the node group."
}

variable "max_size" {
  type        = number
  description = "(Required) The maximum number of nodes to create in the node group."
}

variable "pub_sub_cidr" {
  type        = list(string)
  description = "(Required) A list of subnet IDs to launch nodes in. Subnets automatically determine which availability zones the node group will reside."
}

variable "vpc_id" {
  type        = string
  description = "(Required) The VPC ID to use for the worker nodes."
}

variable "source_security_group_id" {
  type        = string
  description = "(Required) The Master node SG Id to use for the worker nodes."
}

variable "eks_version" {
  type = string
}

variable "aws_eks_cluster_endpoint" {
  type = string
}

variable "aws_eks_cluster_certificate_authority" {
  type = string
}


#____________________________________Variables for VPC_____________________________________

variable "region" {
  type        = string
  description = "Region where VPC will be deployed"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of VPC"
}

variable "instance_tenancy" {
  type        = string
  description = "Instance tenancy"
}

variable "enable_dns_support" {
  type        = string
  description = "DSN support [true/false]"
}

variable "enable_dns_hostnames" {
  type        = string
  description = "DSN hostname [true/false]"
}

variable "enable_classiclink" {
  type        = string
  description = "Classic link [true/false]"
}


variable "pub_sub_cidr" {
  type        = list(any)
  description = "CIDR block of public subnet"
}

variable "priv_sub_cidr" {
  type        = list(string)
  description = "CIDR block of private subnet"
}



#____________________________________Variables for Security group_________________________________

variable "ports" {
  type        = list(number)
  description = "Allowed ports"
}

#____________________________________Variables EKS_________________________________

variable "cluster_role" {
  type = string
}

variable "cluster_name" {
  type = string
}

#____________________________________Variables Node group EKS_________________________________

# -----------------------------------------------------------------------------
# Required input variables
# -----------------------------------------------------------------------------
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


/* variable "vpc_id" {
  type        = string
  description = "(Required) The VPC ID to use for the worker nodes."
}

variable "source_security_group_id" {
  type        = string
  description = "(Required) The Master node SG Id to use for the worker nodes."
}
 */
variable "eks_version" {
  type = string
}

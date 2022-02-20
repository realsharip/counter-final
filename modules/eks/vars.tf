variable "subnet_ids" {
  type = list(any)
}

variable "cluster_role" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}
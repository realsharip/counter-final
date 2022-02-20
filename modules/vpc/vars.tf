variable "region" {
  type = string
}


variable "vpc_cidr_block" {
  type = string
}

variable "pub_sub_cidr" {
  type = list(any)
}

variable "priv_sub_cidr" {
  type = list(any)
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


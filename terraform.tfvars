#____________________Provider AWS_______________________________________
region = "us-east-2"

#____________________VPC________________________________________________
vpc_cidr_block       = "10.0.0.0/16"
instance_tenancy     = "default"
enable_dns_support   = "true"
enable_dns_hostnames = "true"
enable_classiclink   = "false"
pub_sub_cidr         = ["10.0.1.0/24", "10.0.2.0/24"]
priv_sub_cidr        = ["10.0.4.0/24", "10.0.5.0/24"]
ports                = [22, 80, 443]

##____________________EKS cluster_______________________________________
cluster_role = "eks-cluster-role"
cluster_name = "realeks"

# ----------------------NODE GROUP-------------------------------------------------------
instance_type    = "t2.medium"
desired_capacity = 3
min_size         = 1
max_size         = 4
eks_version      = "1.18"
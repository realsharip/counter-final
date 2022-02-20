
/* Eldiar tips:
He used count functions and lifecycle(create before destroy) in aws_route_table_association
also he add depends on block there */

locals {
  cluster_name = "realeks"
}

# Creating VPC for our infrastructure
resource "aws_vpc" "vpc_eks" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_classiclink   = var.enable_classiclink
  tags = {
    Name        = "VPC-EKS"
    Environment = "dev"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}
#__________________________________Creating public subnet_________________________________

resource "aws_subnet" "pub_eks_1" {
  vpc_id                  = aws_vpc.vpc_eks.id
  cidr_block              = var.pub_sub_cidr[0]
  availability_zone       = data.aws_availability_zones.available.names[0] #us-east-1b
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "Public-EKS-b"
    Environment = "dev"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}

resource "aws_subnet" "pub_eks_2" {
  vpc_id                  = aws_vpc.vpc_eks.id
  cidr_block              = var.pub_sub_cidr[1]
  availability_zone       = data.aws_availability_zones.available.names[1] #us-east-1b
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "Public-EKS-b"
    Environment = "dev"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}


#____________________________Creating private subnets____________________________

 resource "aws_subnet" "priv_eks_1" {
  vpc_id            = aws_vpc.vpc_eks.id
  cidr_block        = var.priv_sub_cidr[0]
  availability_zone = data.aws_availability_zones.available.names[0] #us-east-1a

  tags = {
    Name        = "Private-EKS-a"
    Environment = "dev"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

resource "aws_subnet" "priv_eks_2" {
  vpc_id            = aws_vpc.vpc_eks.id
  cidr_block        = var.priv_sub_cidr[1]
  availability_zone = data.aws_availability_zones.available.names[1] #us-east-1b

  tags = {
    Name        = "Private-EKS-b"
    Environment = "dev"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

#_____________________________________Internet Gateway_________________________________

resource "aws_internet_gateway" "eks_gw" {
  vpc_id = aws_vpc.vpc_eks.id

  tags = {
    Name        = "EKS-IGW"
    Environment = "dev"
  }
}

#_____________________________________Route Table______________________________________

resource "aws_route_table" "rt_eks" {
  vpc_id = aws_vpc.vpc_eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_gw.id
  }

  tags = {
    Name        = "EKS-rt"
    Environment = "dev"
  }
}

#_____________________________________Subnet Association______________________________________

resource "aws_route_table_association" "eks-a" {
  subnet_id      = aws_subnet.pub_eks_1.id
  route_table_id = aws_route_table.rt_eks.id
  depends_on = [
    aws_subnet.pub_eks_1,
    aws_subnet.pub_eks_2,
    aws_route_table.rt_eks
  ]
}

resource "aws_route_table_association" "eks-b" {
  subnet_id      = aws_subnet.pub_eks_2.id
  route_table_id = aws_route_table.rt_eks.id
}

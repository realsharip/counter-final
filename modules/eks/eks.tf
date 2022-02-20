#_____________________Creating role for EKS cluster_____________________________

resource "aws_iam_role" "eks_role" {
  name = var.cluster_role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

#__________________________Attach policy to this role___________________________

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}
#### Consider one more policy attachment(AmazonEKSservicePolicy)

#_________________________EKS SG Master______________________________________

resource "aws_security_group" "master" {
  name        = "master"
  description = "Allow internal communication"
  vpc_id      = var.vpc_id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.cluster_name}_MN_sg"
  }
}

#_________________________EKS cluster itself______________________________________

resource "aws_eks_cluster" "realeks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version  = "1.18"
  vpc_config {
    subnet_ids             = var.subnet_ids
    endpoint_public_access = true
    security_group_ids     = [aws_security_group.master.id]
    # we need create security group as well(Master node SG / Control Plane SG)
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
  aws_iam_role_policy_attachment.amazon_eks_service_policy]
}

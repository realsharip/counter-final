resource "aws_iam_role" "nodes_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "eks_ebs_policy" {
  name   = "Amazon_EBS_CSI_Driver"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_role.name
}


#____________________________Worker node group instance profile________________________________

resource "aws_iam_instance_profile" "worker_nodes" {
  name = "${var.cluster_name}_worker_nodes"
  role = aws_iam_role.nodes_role.name
}

#___________________________Worker nodes SG____________________________________________________

resource "aws_security_group" "eks_worker" {
  name   = "${var.cluster_name}-worker_nodes"
  vpc_id = var.vpc_id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name                                        = "${var.cluster_name}_WN_sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_security_group_rule" "ingress-self" {
  type                     = "ingress"
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_worker.id
  source_security_group_id = aws_security_group.eks_worker.id
}


resource "aws_security_group_rule" "ingress-cluster-https" {
  type                     = "ingress"
  description              = "Allow worker kubelets and pods receive communication from the cluster control plane"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker.id
  source_security_group_id = var.source_security_group_id        #aws_security_group.master.id ####################
}

resource "aws_security_group_rule" "ingress-cluster-others" {
  type                     = "ingress"
  description              = "Allow nodes to communicate with each other"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker.id
  source_security_group_id = var.source_security_group_id         #aws_security_group.master.id ####################
}

resource "aws_security_group_rule" "ingress-node-https" {
  type                     = "ingress"
  description              = "Allow nodes to communicate with each other"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = var.source_security_group_id #################### Master
  source_security_group_id = aws_security_group.eks_worker.id
}

data "aws_ami" "eks_worker_ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.eks_version}-v*"] ###########
  }
  most_recent = true
  owners      = ["amazon"]
}


#Bootstrap userdata for worker nodes

locals {
  node_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${var.aws_eks_cluster_endpoint}' --b64-cluster-ca '${var.aws_eks_cluster_certificate_authority}' '${var.cluster_name}'
USERDATA
}



#_______________________________________Launch Template for working nodes

resource "aws_launch_template" "eks-template" {
  name_prefix            = "sharip"
  image_id               = data.aws_ami.eks_worker_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.eks_worker.id]
  user_data              = base64encode(local.node_userdata)
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.worker_nodes.name ######
  }
}

#__________________________________________Autoscaling for worker node

resource "aws_autoscaling_group" "myasg" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.pub_sub_cidr ###
  name                = "sharip-asg"


  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 1
      on_demand_percentage_above_base_capacity = 20
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks-template.id
      }

      override {
        instance_type = "t2.medium"
      }

      override {
        instance_type = "t3.medium"
      }
    }
  }
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = "Counter-worker"
    propagate_at_launch = true
  }
}


/*   tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "TRUE"
    propagate_at_launch = true
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/${local.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
} */
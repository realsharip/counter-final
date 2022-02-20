/* 
resource "aws_security_group" "sg_eks" {
  name = "sg_eks"
  vpc_id = var.vpc_id
  #vpc_id = module.aws_vpc.vpc_eks.id

  dynamic "ingress" {
    for_each = var.ports
    content {
      description      = "allow http traffic"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }


  egress = [
    {
      description      = "allow http traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "EKS-sg"
  }
}

*/
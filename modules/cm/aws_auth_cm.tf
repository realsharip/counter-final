locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
   - rolearn: ${var.eks_wn_role_arn}
     username: system:node:{{EC2PrivateDNSName}}
     groups:
       - system:bootstrappers
       - system:nodes
CONFIGMAPAWSAUTH
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

variable "eks_wn_role_arn" {
  type = string
}

resource "local_file" "config" {
  content = local.config_map_aws_auth
  filename = "./aws_auth/config_map_aws_auth.yaml"
}
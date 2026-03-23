#data "aws_caller_identity" "current" {}
#
#locals {
#  current_role_name = element(split("/", data.aws_caller_identity.current.arn), 1)
#
#  current_principal_arn = "arn:aws:iam::${var.aws_account_id}:role/LabRole"
#
#  effective_eks_access_entries = merge(
#    {
#      current = {
#        principal_arn = local.current_principal_arn
#        type          = "STANDARD"
#        policy_associations = {
#          admin = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#        }
#      }
#    },
#    var.eks_access_entries
#  )
#
#  eks_access_policy_associations = flatten([
#    for entry_key, entry_val in local.effective_eks_access_entries : [
#      for pol_key, pol_arn in lookup(entry_val, "policy_associations", {}) : {
#        entry_key     = entry_key
#        pol_key       = pol_key
#        principal_arn = entry_val.principal_arn
#        policy_arn    = pol_arn
#      }
#    ]
#  ])
#}

resource "aws_eks_cluster" "this" {
  name     = var.eks_cluster_name
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/LabRole"
  version  = var.eks_kubernetes_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = var.eks_cluster_endpoint_public_access
    endpoint_private_access = var.eks_cluster_endpoint_private_access
  }

  tags = var.tags
}

resource "aws_eks_node_group" "managed" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "prod_nodes"
  node_role_arn   = "arn:aws:iam::${var.aws_account_id}:role/LabRole"

  subnet_ids = var.private_subnet_ids

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  labels = {
    environment = "prod"
    node-type  = "general"
  }

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 3
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-eks-node-group"
    }
  )
}
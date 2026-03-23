data "aws_caller_identity" "current" {}

locals {
  current_role_name = element(split("/", data.aws_caller_identity.current.arn), 1)

  current_principal_arn = "arn:aws:iam::${var.aws_account_id}:role/LabRole"

  effective_eks_access_entries = merge(
    {
      current = {
        principal_arn = local.current_principal_arn
        type          = "STANDARD"
        policy_associations = {
          admin = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        }
      }
    },
    var.eks_access_entries
  )

  eks_access_policy_associations = flatten([
    for entry_key, entry_val in local.effective_eks_access_entries : [
      for pol_key, pol_arn in lookup(entry_val, "policy_associations", {}) : {
        entry_key     = entry_key
        pol_key       = pol_key
        principal_arn = entry_val.principal_arn
        policy_arn    = pol_arn
      }
    ]
  ])
}

resource "aws_eks_cluster" "this" {
  name     = var.eks_cluster_name
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/LabRole"
  version  = var.eks_kubernetes_version

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = var.eks_cluster_endpoint_public_access
    endpoint_private_access = var.eks_cluster_endpoint_private_access
  }

  tags = var.tags
}

resource "aws_launch_template" "eks_nodes" {
  for_each = var.eks_managed_node_groups

  name_prefix = "${var.project_name}-${each.key}-"
  description = "Launch template for ${each.key} node group"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-${each.key}-node"
      }
    )
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${each.key}-lt"
    }
  )
}

resource "aws_eks_node_group" "managed" {
  for_each = var.eks_managed_node_groups

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.key
  node_role_arn   = var.eks_node_group_role_arn != "" ? var.eks_node_group_role_arn : "arn:aws:iam::${var.aws_account_id}:role/LabRole"

  subnet_ids = var.private_subnet_ids

  ami_type       = try(each.value.ami_type, null)
  capacity_type  = try(replace(upper(each.value.capacity_type), "ONDEMAND", "ON_DEMAND"), null)
  instance_types = try(each.value.instance_types, null)

  labels = try(each.value.k8s_labels, null)

  dynamic "taint" {
    for_each = try(each.value.taints, [])
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  scaling_config {
    desired_size = try(each.value.desired_size, 2)
    max_size     = try(each.value.max_size, 3)
    min_size     = try(each.value.min_size, 2)
  }

  launch_template {
    id      = aws_launch_template.eks_nodes[each.key].id
    version = "$Latest"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${each.key}"
    }
  )
}

resource "aws_eks_access_entry" "this" {
  for_each = local.effective_eks_access_entries

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.principal_arn
  type          = try(each.value.type, "STANDARD")
}

resource "aws_eks_access_policy_association" "this" {
  for_each = {
    for v in local.eks_access_policy_associations : "${v.entry_key}_${v.pol_key}" => v
  }

  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = each.value.policy_arn
  principal_arn = each.value.principal_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.this]
}

data "aws_security_groups" "nodegroup_sg" {
  depends_on = [aws_eks_node_group.managed]

  filter {
    name   = "tag:eks:cluster-name"
    values = [var.eks_cluster_name]
  }
}
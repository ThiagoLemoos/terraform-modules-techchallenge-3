locals {
  azs = var.eks_availability_zones
 
  public_subnets  = [for i in range(length(local.azs)) : cidrsubnet(var.cidr_block, 4, i)]
  private_subnets = [for i, az in local.azs : cidrsubnet(var.cidr_block, 4, i + 10)]
}

module "eks" {
    source  = "terraform-aws-modules/eks/aws" 
    version = "~> 20.17" 

    cluster_name    = var.eks_cluster_name
    cluster_version = var.eks_kubernetes_version

    vpc_id     = module.vpc.vpc_id 
    subnet_ids = module.vpc.private_subnets 
    

    cluster_endpoint_public_access  = var.eks_cluster_endpoint_public_access 
    cluster_endpoint_private_access = var.eks_cluster_endpoint_private_access 
  
    enable_irsa = var.eks_enable_irsa 

    enable_cluster_creator_admin_permissions = var.eks_enable_cluster_creator_admin_permissions 

    cluster_security_group_additional_rules = {
      ingress_vpc_api_443 = {
        description = "Allow VPC CIDR to access Kubernetes API server"
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        type        = "ingress"
        cidr_blocks = [module.vpc.vpc_cidr_block]
      }
    }

    cluster_addons = {
      vpc-cni = {
        most_recent              = true
        resolve_conflicts        = "OVERWRITE"
        resolve_conflicts_on_create = "OVERWRITE"
      }
      coredns = {
        most_recent              = true
        resolve_conflicts        = "OVERWRITE"
        resolve_conflicts_on_create = "OVERWRITE"
        configuration_values = jsonencode({
          nodeSelector = {
            nodepool = "system"
            workload = "system"
          }
          tolerations = [
            {
              key = "dedicated"
              operator = "Equal"
              value = "system"
              effect = "NoSchedule"
            }
          ]
        })
      }
      kube-proxy = {
        most_recent              = true
        resolve_conflicts        = "OVERWRITE"
        resolve_conflicts_on_create = "OVERWRITE"
      }
      
    }

    eks_managed_node_group_defaults = {
      tags = var.eks_tags
    }
    
    access_entries = var.eks_access_entries

    eks_managed_node_groups = var.eks_managed_node_groups
    tags = var.eks_tags 
}


module "elasticache" {
  source = "terraform-aws-modules/elasticache/aws"
  version = "1.11.0"

  cluster_id               = var.elasticache_cluster_id
  create_cluster           = var.create_elasticache
  create_replication_group = var.create_elasticache_replication_group

  engine          = var.elasticache_engine
  engine_version  = var.elasticache_engine_version
  node_type       = var.elasticache_node_type
  num_cache_nodes = var.elasticache_num_cache_nodes
  az_mode         = var.elasticache_az_mode

  maintenance_window = "sun:05:00-sun:09:00"
  apply_immediately  = true

  # Security group
  vpc_id = var.vpc_id
  security_group_rules = {
    ingress_vpc = {
      # Default type is `ingress`
      # Default port is based on the default engine port
      description = "VPC traffic"
      cidr_ipv4   = var.vpc_cidr_block
    }
  }

  # Subnet Group
  subnet_ids = var.private_subnet_ids

  # Parameter Group
  create_parameter_group = false

}

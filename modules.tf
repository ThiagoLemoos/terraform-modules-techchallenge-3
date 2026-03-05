locals {
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  project_name = var.project_name
 
  public_subnets  = [for i in range(length(local.azs)) : cidrsubnet(var.cidr_block, 8, i)]
}

module "vpc" {
  source  = "./modules/network"

  aws_region   = var.aws_region
  project_name = local.project_name
  cidr_block   = var.cidr_block
  tags         = var.tags
}

module "documentdb" {
  source = "./modules/documentdb"
  aws_region = var.aws_region
  project_name = local.project_name
  aws_docdb_name = var.aws_docdb_name
  aws_docdb_description = var.aws_docdb_description
  aws_docdb_subnet_ids = var.aws_docdb_subnet_ids
  aws_docdb_cluster_identifier = var.aws_docdb_cluster_identifier
  aws_docdb_engine = var.aws_docdb_engine
  aws_docdb_engine_version = var.aws_docdb_engine_version
  aws_docdb_db_username = var.aws_docdb_db_username
  aws_docdb_db_password = var.aws_docdb_db_password
  aws_docdb_count_instances = var.aws_docdb_count_instances
  aws_docdb_instance_class = var.aws_docdb_instance_class
  aws_docdb_skip_final_snapshot = var.aws_docdb_skip_final_snapshot
  aws_docdb_storage_encrypted = var.aws_docdb_storage_encrypted
  aws_docdb_backup_retention_period = var.aws_docdb_backup_retention_period
  aws_docdb_tls_enabled = var.aws_docdb_tls_enabled
  aws_docdb_availability_zones = var.aws_docdb_availability_zones
  tags = var.tags
}
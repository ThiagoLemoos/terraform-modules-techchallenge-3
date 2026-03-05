resource "aws_docdb_cluster_parameter_group" "docdb_params" {
  name        = "docdb-params-no-tls"
  family      = "docdb4.0"
  description = "Desabilita TLS"

  parameter {
    name  = "tls"
    value = var.aws_docdb_tls_enabled ? "enabled" : "disabled"
  }
}

resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = var.aws_docdb_name
  description = var.aws_docdb_description
  subnet_ids = var.aws_docdb_subnet_ids
}

resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier      = var.aws_docdb_cluster_identifier
  engine                  = var.aws_docdb_engine
  engine_version          = var.aws_docdb_engine_version
  master_username         = var.aws_docdb_db_username
  master_password         = var.aws_docdb_db_password
  skip_final_snapshot     = var.aws_docdb_skip_final_snapshot
  storage_encrypted       = var.aws_docdb_storage_encrypted
  backup_retention_period = var.aws_docdb_backup_retention_period
  db_subnet_group_name    = var.aws_docdb_name
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.docdb_params.name
  availability_zones = var.aws_docdb_availability_zones
}

resource "aws_docdb_cluster_instance" "docdb_instance" {
  count              = var.aws_docdb_count_instances
  identifier         = "db-mobilemed-prod-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = var.aws_docdb_instance_class
}
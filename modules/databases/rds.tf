module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.username
  port     = var.port

  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  vpc_security_group_ids = var.vpc_security_group_ids

  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = var.monitoring_interval
  monitoring_role_name   = var.monitoring_role_name
  create_monitoring_role = var.create_monitoring_role

  tags = var.tags

  # DB subnet group
  create_db_subnet_group = var.create_db_subnet_group
  subnet_ids             = var.subnet_ids

  # DB parameter group
  family = var.family

  # DB option group
  major_engine_version = var.major_engine_version

  # Database Deletion Protection
  deletion_protection = var.deletion_protection

  parameters = var.parameters

  options = var.options
}
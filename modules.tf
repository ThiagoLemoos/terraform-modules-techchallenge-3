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
  cluster_name = "${local.project_name}-eks"
}

module "rds" {
  source = "./modules/databases"
  
  # Variáveis principais
  project_name = var.project_name
  aws_region   = var.aws_region
  tags         = var.tags
  
  # Variáveis do RDS
  identifier                           = "techchallenge-db"
  engine                               = "mysql"
  engine_version                       = "8.0"
  instance_class                       = "db.t3a.large"
  allocated_storage                    = 20
  db_name                              = "techchallenge"
  username                             = "admin"
  port                                 = 3306
  
  # Configurações de segurança
  iam_database_authentication_enabled   = true
  vpc_security_group_ids               = []  # Será preenchido após criação da VPC
  
  # Janelas de manutenção
  maintenance_window                   = "Mon:00:00-Mon:03:00"
  backup_window                        = "03:00-06:00"
  
  # Monitoring
  monitoring_interval                  = "30"
  monitoring_role_name                 = "TechChallengeRDSMonitoringRole"
  create_monitoring_role               = true
  
  # Configurações de subnet
  create_db_subnet_group               = true
  subnet_ids                          = []  # Será preenchido após criação da VPC
  
  # Configurações de engine
  family                               = "mysql8.0"
  major_engine_version                 = "8.0"
  
  # Proteção
  deletion_protection                  = true
  
  # Parâmetros e options
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    },
    {
      name  = "collation_server"
      value = "utf8mb4_unicode_ci"
    }
  ]
  
  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"
      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        }
      ]
    }
  ]
}
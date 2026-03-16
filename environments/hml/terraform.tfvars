# =============================================================================
# VARIÁVEIS GLOBAIS DO PROJETO
# =============================================================================
aws_region   = "us-east-1"
project_name = "togglemaster_hml"
cidr_block   = "10.0.0.0/16"

# =============================================================================
# VARIÁVEIS DO MÓDULO NETWORK (VPC)
# =============================================================================
network_tags = {
  team       = "DevOps"
  project    = "togglemaster"
  environment = "Homolog"
  managedBy  = "Terraform"
  Name       = "togglemaster-vpc-hml"
}

network_cluster_name = "togglemaster-eks-hml"

# =============================================================================
# VARIÁVEIS DO MÓDULO EKS-CLUSTER
# =============================================================================
eks_cluster_name = "togglemaster-eks-hml"
eks_kubernetes_version = "1.29"

eks_tags = {
  team       = "Academy"
  project    = "togglemaster"
  environment = "homolog"
  managedBy  = "Terraform"
  Name       = "togglemaster-eks-hml"
}

# Configuração dos Node Groups para Academy (otimizado para LabRole)
eks_managed_node_groups = {
  academy_nodes = {
    instance_types = ["t3.medium"]  # Instância compatível com LabRole
    min_size       = 1
    max_size       = 3
    desired_size   = 2
    capacity_type  = "ONDEMAND"
    ami_type       = "AL2_x86_64"
    
    # Configurações específicas para Academy
    k8s_labels = {
      environment = "Homolog"
      node-type  = "general"
    }
    
    taints = []
  }
}

# Configuração de acesso IAM para Academy (LabRole)
eks_access_entries = {
  academy_labrole = {
    principal_arn = "arn:aws:iam::471112638215:role/LabRole"  # Substituir ACCOUNT pelo ID da conta
    policy_associations = {
      cluster_admin = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    }
  }
}

# =============================================================================
# VARIÁVEIS DO MÓDULO DATABASES (RDS)
# =============================================================================
rds_identifier = "togglemaster-db-hml"
rds_engine     = "postgres"
rds_engine_version = "15.4"
rds_instance_class = "db.t3.micro"  # Instância menor para Academy
rds_allocated_storage = 20

rds_db_name  = "techchallenge_hml"
rds_username = "academy_admin"
rds_port     = "5432"

# Configurações de segurança para Academy
rds_iam_database_authentication_enabled = true
rds_vpc_security_group_ids = []

# Janelas de manutenção (fora do horário de Academy)
rds_maintenance_window = "Sun:02:00-Sun:04:00"
rds_backup_window      = "04:00-06:00"

# Configurações de monitoring para Academy
rds_monitoring_interval    = "0"  # Desabilitado para economizar custos
rds_monitoring_role_name   = "TechChallengeAcademyRDSMonitoringRole"
rds_create_monitoring_role = false  # Desabilitado para Academy

# Configurações de subnet
rds_create_db_subnet_group = true
rds_subnet_ids = []

# Configurações de engine PostgreSQL
rds_family = "postgres15"
rds_major_engine_version = "15"

# Proteção contra deleção (permitido apenas via Terraform para Academy)
rds_deletion_protection = false

# Parâmetros otimizados para Academy
rds_parameters = [
  {
    name  = "max_connections"
    value = "100"
  },
  {
    name  = "shared_buffers"
    value = "128MB"
  },
  {
    name  = "work_mem"
    value = "1024"
  },
  {
    name  = "maintenance_work_mem"
    value = "16MB"
  },
  {
    name  = "checkpoint_completion_target"
    value = "0.7"
  },
  {
    name  = "wal_buffers"
    value = "4MB"
  },
  {
    name  = "default_statistics_target"
    value = "50"
  }
]

# Options do PostgreSQL (mínimo para Academy)
rds_options = []

# Tags específicas para RDS
rds_tags = {
  team       = "DevOps"
  project    = "togglemaster"
  environment = "Homolog"
  managedBy  = "Terraform"
  Name       = "togglemaster-rds-hml"
}

# =============================================================================
# VARIÁVEIS DO MÓDULO DATABASES (DYNAMODB)
# =============================================================================
dynamodb_tables = [
  {
    name           = "togglemaster-sessions-hml"
    hash_key       = "session_id"
    billing_mode   = "PAY_PER_REQUEST"
    attributes = [
      {
        name = "session_id"
        type = "S"
      }
    ]
    tags = {
      team       = "AcaDevOpsdemy"
      project    = "togglemaster"
      environment = "Homolog"
      managedBy  = "Terraform"
      Name       = "togglemaster-sessions-hml"
    }
  },
  {
    name           = "togglemaster-logs-hml"
    hash_key       = "log_id"
    billing_mode   = "PAY_PER_REQUEST"
    attributes = [
      {
        name = "log_id"
        type = "S"
      }
    ]
    tags = {
      team       = "DevOps"
      project    = "togglemaster"
      environment = "Homolog"
      managedBy  = "Terraform"
      Name       = "togglemaster-logs-hml"
    }
  }
]

# =============================================================================
# VARIÁVEIS DE TAGS GLOBAIS
# =============================================================================
global_tags = {
  team       = "DevOps"
  project    = "togglemaster"
  environment = "Homolog"
  managedBy  = "Terraform"
  owner      = "AcademyStudent"
  cost-center = "Education"
}

# =============================================================================
# VARIÁVEIS DO MÓDULO DATABASES (ELASTICACHE)
# =============================================================================
elasticache_cluster_id = "togglemaster-redis-hml"
elasticache_replication_group_id = "togglemaster-redis-repl-hml"
create_elasticache = false
create_elasticache_replication_group = false

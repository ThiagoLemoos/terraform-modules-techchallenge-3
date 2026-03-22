# =============================================================================
# VARIÁVEIS GLOBAIS DO PROJETO
# =============================================================================
aws_region   = "us-east-1"
project_name = "togglemaster"
cidr_block   = "10.0.0.0/16"
aws_account_id = "057096910794"  # Substituir pelo ID da conta real

# =============================================================================
# VARIÁVEIS DO MÓDULO NETWORK (VPC)
# =============================================================================
network_tags = {
  team       = "DevOps"
  project    = "togglemaster"
  environment = "Homolog"
  managedBy  = "Terraform"
  Name       = "togglemaster-vpc"
}

network_cluster_name = "togglemaster-eks"

# Variáveis de otimização de custos e configuração
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
enable_nat_gateway       = true
single_nat_gateway       = true
one_nat_gateway_per_az   = false
enable_flow_log         = true
enable_dns_hostnames    = true
enable_dns_support      = true
assign_ipv6_address     = false
enable_ipv6            = false

# =============================================================================
# VARIÁVEIS DO MÓDULO EKS-CLUSTER
# =============================================================================
eks_cluster_name = "togglemaster-eks-hml"
eks_kubernetes_version = "1.32"

eks_tags = {
  team       = "DevOps"
  project    = "togglemaster"
  environment = "Homolog"
  managedBy  = "Terraform"
  Name       = "togglemaster-eks-hml"
}

eks_enable_irsa = false

eks_managed_node_groups = {
  hml_nodes = {
    instance_types = ["t3.medium"]
    min_size       = 1
    max_size       = 1
    desired_size   = 1
    capacity_type  = "ON_DEMAND"
    ami_type       = "AL2023_x86_64_STANDARD"
    
    k8s_labels = {
      environment = "homolog"
      node-type  = "general"
    }
    
    taints = []
  }
}

eks_access_entries = {
  hml_admin = {
    principal_arn = "arn:aws:iam::654654467270:role/LabRole"
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
rds_engine_version = "15"
rds_instance_class = "db.t3.micro"  # Instância menor para Academy
rds_allocated_storage = 20

rds_db_name  = "togglemaster_hml"
rds_username = "togglemaster_admin"
rds_port     = "5432"

# Configurações de segurança para Academy
rds_iam_database_authentication_enabled = false
rds_vpc_security_group_ids = []

# Janelas de manutenção (fora do horário de Academy)
rds_maintenance_window = "Sun:02:00-Sun:04:00"
rds_backup_window      = "04:00-06:00"

# Configurações de monitoring para Homolog
rds_monitoring_interval    = "0"
rds_create_monitoring_role = false

# Configurações de subnet
rds_create_db_subnet_group = true
rds_subnet_ids = []

# Configurações de engine PostgreSQL
rds_family = "postgres15"
rds_major_engine_version = "15"

# Proteção contra deleção
rds_deletion_protection = false

# Parâmetros otimizados para Homolog
rds_parameters = [
  {
    name  = "checkpoint_completion_target"
    value = "0.9"
  },
  {
    name  = "default_statistics_target"
    value = "100"
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
      team       = "DevOps"
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

dynamodb_table_name = "togglemaster-hml"

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

tags = {
  team       = "DevOps"
  project    = "togglemaster"
  environment = "Homolog"
  managedBy  = "Terraform"
}

# =============================================================================
# VARIÁVEIS DO MÓDULO ECR
# =============================================================================
repository_name = [
  "auth-service",
  "flag-service",
  "targeting-service",
  "evaluation-service",
  "analytics-service"
]

# =============================================================================
# VARIÁVEIS DO MÓDULO DATABASES (ELASTICACHE)
# =============================================================================
elasticache_cluster_id = "togglemaster-redis-hml"
elasticache_replication_group_id = "togglemaster-redis-repl-hml"
create_elasticache = false
create_elasticache_replication_group = false

# =============================================================================
# VARIÁVEIS DO MÓDULO EKS (AWS ACADEMY)
# =============================================================================
enable_iam_session_context = false  # Desabilitar para AWS Academy

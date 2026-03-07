variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "tags" {
  description = "Tags for the RDS instance"
  type        = map(string)
  default = {}
}

# Variáveis do RDS
variable "rds_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "rds_engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.4"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_db_name" {
  description = "Database name"
  type        = string
}

variable "rds_username" {
  description = "Master username"
  type        = string
}

variable "rds_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "rds_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "rds_iam_database_authentication_enabled" {
  description = "Enable IAM database authentication"
  type        = bool
  default     = false
}

variable "rds_vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
  default     = []
}

variable "rds_maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "Sun:02:00-Sun:04:00"
}

variable "rds_backup_window" {
  description = "Backup window"
  type        = string
  default     = "04:00-06:00"
}

variable "rds_monitoring_interval" {
  description = "Enhanced Monitoring interval"
  type        = string
  default     = "0"
}

variable "rds_monitoring_role_name" {
  description = "Monitoring role name"
  type        = string
  default     = "ToggleMasterRDSMonitoringRole"
}

variable "rds_create_monitoring_role" {
  description = "Create monitoring role"
  type        = bool
  default     = false
}

variable "rds_create_db_subnet_group" {
  description = "Create DB subnet group"
  type        = bool
  default     = true
}

variable "rds_subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default     = []
}

variable "rds_family" {
  description = "DB parameter group family"
  type        = string
  default     = "postgres15"
}

variable "rds_major_engine_version" {
  description = "Major engine version"
  type        = string
  default     = "15"
}

variable "rds_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "rds_parameters" {
  description = "DB parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "rds_options" {
  description = "DB options"
  type = list(object({
    option_name = string
    option_settings = list(object({
      name  = string
      value = string
    }))
  }))
  default = []
}
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
variable "identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3a.large"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "iam_database_authentication_enabled" {
  description = "Enable IAM database authentication"
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
  default     = []
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-06:00"
}

variable "monitoring_interval" {
  description = "Enhanced Monitoring interval"
  type        = string
  default     = "30"
}

variable "monitoring_role_name" {
  description = "Monitoring role name"
  type        = string
  default     = "RDSMonitoringRole"
}

variable "create_monitoring_role" {
  description = "Create monitoring role"
  type        = bool
  default     = true
}

variable "create_db_subnet_group" {
  description = "Create DB subnet group"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default     = []
}

variable "family" {
  description = "DB parameter group family"
  type        = string
  default     = "mysql8.0"
}

variable "major_engine_version" {
  description = "Major engine version"
  type        = string
  default     = "8.0"
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "parameters" {
  description = "DB parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "options" {
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
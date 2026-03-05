# variables example:

variable "aws_region" {
  type        = string
  description = "AWS Region for resources deployment"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name to identify VPC"
  default     = "mobilemed"
}

variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all resources."
  default = {
    team    = "Devops"
    project = "env-techchallenge"
    environment = "Prod"
    managedBy = "Terraform"
  }
}


# DocumentDB Variables
variable "aws_docdb_name" {
  description = "Name for the DocumentDB cluster"
  type        = string
}

variable "aws_docdb_description" {
  description = "Description for the DocumentDB cluster"
  type        = string
}

variable "aws_docdb_subnet_ids" {
  description = "List of VPC subnet IDs for DocumentDB deployment"
  type        = list(string)
}

variable "aws_docdb_cluster_identifier" {
  description = "Identifier for the DocumentDB cluster"
  type        = string
}

variable "aws_docdb_engine" {
  description = "Engine for the DocumentDB cluster"
  type        = string
}

variable "aws_docdb_engine_version" {
  description = "Engine version for the DocumentDB cluster"
  type        = string
}

variable "aws_docdb_db_username" {
  description = "Username for the DocumentDB cluster"
  type        = string
}

variable "aws_docdb_db_password" {
  description = "Password for the DocumentDB cluster"
  type        = string
  sensitive   = true
}

variable "aws_docdb_count_instances" {
  description = "Number of instances for the DocumentDB cluster"
  type        = number
}

variable "aws_docdb_instance_class" {
  description = "Instance class for the DocumentDB cluster"
  type        = string
}

variable "aws_docdb_skip_final_snapshot" {
  description = "Skip final snapshot for the DocumentDB cluster"
  type        = bool
}

variable "aws_docdb_storage_encrypted" {
  description = "Enable storage encryption for the DocumentDB cluster"
  type        = bool
}

variable "aws_docdb_backup_retention_period" {
  description = "Backup retention period for the DocumentDB cluster"
  type        = number
}

variable "aws_docdb_tls_enabled" {
  description = "Enable TLS for the DocumentDB cluster"
  type        = bool
}

variable "aws_docdb_availability_zones" {
  description = "Availability zones for the DocumentDB cluster"
  type        = list(string)
}
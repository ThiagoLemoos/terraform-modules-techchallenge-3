
variable "aws_region" {
  type        = string
  description = "AWS Region for resources deployment"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name to identify VPC"
  default     = "prod-techchallenge"
}

variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR block for VPC"
  default     = "10.50.0.0/16"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all resources."
  default = {
    team    = "Devops"
    project = "prod-techchallenge"
    environment = "Prod"
    managedBy = "Terraform"
  }
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "togglemaster-eks"
}

variable "eks_kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.28"
}

variable "eks_tags" {
  type        = map(any)
  description = "Tags for EKS resources"
  default     = {}
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node groups configuration"
  type        = any
  default = {}
}

variable "eks_access_entries" {
  description = "Map of IAM principals to grant EKS access"
  type        = any
  default     = {}
}

# VPC-related variables for EKS
variable "vpc_id" {
  description = "VPC ID for EKS"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block for EKS security group"
  type        = string
}

variable "eks_availability_zones" {
  description = "List of availability zones for EKS cluster"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "eks_cluster_endpoint_public_access" {
  description = "Enable public access to EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "eks_cluster_endpoint_private_access" {
  description = "Enable private access to EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "eks_enable_irsa" {
  description = "Enable IAM Roles for Service Accounts (IRSA)"
  type        = bool
  default     = true
}

variable "eks_enable_cluster_creator_admin_permissions" {
  description = "Enable cluster creator admin permissions"
  type        = bool
  default     = true
}

variable "enable_iam_session_context" {
  description = "Enable IAM session context check (disable for AWS Academy environments)"
  type        = bool
  default     = false
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}
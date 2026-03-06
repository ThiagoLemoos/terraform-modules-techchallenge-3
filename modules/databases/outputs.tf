output "rds_instance_endpoint" {
  description = "RDS instance endpoint"
  value = module.db.db_instance_endpoint
}

output "rds_instance_id" {
  description = "RDS instance ID"
  value = module.db.db_instance_id
}
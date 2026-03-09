module "dynamodb_table" {
  #External module - community module for DynamoDB
  source   = "terraform-aws-modules/dynamodb-table/aws"
  version  = "5.5.0"

  #Table name
  name     = "${var.project_name}_analytics"

  #Billing mode - pay-per-request
  billing_mode = "PAY_PER_REQUEST"

  #Primary key
  hash_key = "event_id"

  attributes = [
    {
      name = "event_id"
      type = "S"
    }
  ]

  #Additional configurations
  #Point in time recovery enabled
  point_in_time_recovery_enabled = true
  #Protection against deletion
  deletion_protection_enabled = true
  #Encryption
  server_side_encryption_enabled = true

  #Tags
  tags = merge(
    var.tags,
    {
     Name = "${var.project_name}_dynamodb"
    }
  )
}
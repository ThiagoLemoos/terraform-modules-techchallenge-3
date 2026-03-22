#Adding kubernetes secret host url endpoint
#auth-service
resource "kubernetes_secret_v1" "auth_db_secret_host" {
  depends_on = [
    kubernetes_namespace_v1.services["auth-service"]
  ]

  metadata {
    name      = "auth-service-db-secret-host"
    namespace = "auth-service"
  }

  data = {
    DATABASE_URL = "postgres://togglemaster_admin:${var.rds_password}@${var.db_auth_endpoint}/auth_db?sslmode=require"
  }

  type = "Opaque"
}

#flag-service
resource "kubernetes_secret_v1" "flag_db_secret_host" {
  depends_on = [
    kubernetes_namespace_v1.services["flag-service"]
  ]

  metadata {
    name      = "flag-service-db-secret-host"
    namespace = "flag-service"
  }

  data = {
    DATABASE_URL = "postgres://togglemaster_admin:${var.rds_password}@${var.db_auth_endpoint}/flag_db?sslmode=require"
  }

  type = "Opaque"
}

#targeting-service
resource "kubernetes_secret_v1" "targeting_db_secret_host" {
  depends_on = [
    kubernetes_namespace_v1.services["targeting-service"]
  ]

  metadata {
    name      = "targeting-service-db-secret-host"
    namespace = "targeting-service"
  }

  data = {
    DATABASE_URL = "postgres://togglemaster_admin:${var.rds_password}@${var.db_targeting_endpoint}/targeting_db?sslmode=require"
  }

  type = "Opaque"
}

#evaluation-service
data "aws_region" "current" {}
resource "kubernetes_secret_v1" "evaluation_db_endpoint" {
  depends_on = [
    kubernetes_namespace_v1.services["evaluation-service"]
  ]

  metadata {
    name      = "evaluation-service-db-secret-host"
    namespace = "evaluation-service"
  }

  data = {
    REDIS_URL   = "redis://${var.evaluation_db_endpoint}:6379"
    AWS_REGION  = data.aws_region.current.id
    AWS_SQS_URL = var.sqs_queue_url
  }

  type = "Opaque"
}

#analytics-service
resource "kubernetes_secret_v1" "analytics_db_endpoint" {
  depends_on = [
    kubernetes_namespace_v1.services["analytics-service"]
  ]

  metadata {
    name      = "analytics-service-db-secret-host"
    namespace = "analytics-service"
  }

  data = {
    AWS_DYNAMODB_TABLE = var.dynamodb_url
    AWS_REGION         = data.aws_region.current.id
    AWS_SQS_URL        = var.sqs_queue_url
  }

  type = "Opaque"
}
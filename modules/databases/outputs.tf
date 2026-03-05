output "documentdb_cluster_endpoint" {
  description = "DocumentDB cluster endpoint"
  value = aws_docdb_cluster.docdb_cluster.endpoint
}

output "documentdb_cluster_id" {
  description = "DocumentDB cluster ID"
  value = aws_docdb_cluster.docdb_cluster.id
}

output "documentdb_cluster_members" {
  description = "DocumentDB cluster members"
  value = aws_docdb_cluster.docdb_cluster.cluster_members
}
# WARNING: Do NOT rename any of these outputs.
# The grading script reads grading.json and checks for these exact keys.
# Renaming any of them will cause the automated grader to fail.

output "cluster_endpoint" {
  description = "The HTTPS endpoint of the EKS cluster API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "region" {
  description = "The AWS region all resources are deployed in"
  value       = var.aws_region
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "The name of the S3 assets bucket"
  value       = "bedrock-assets-${var.student_id}"
}

output "mysql_endpoint" {
  description = "MySQL RDS endpoint"
  value       = module.rds.mysql_endpoint
}

output "postgres_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = module.rds.postgres_endpoint
}

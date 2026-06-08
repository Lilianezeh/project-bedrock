variable "aws_region" {
  description = "AWS region where all resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "student_id" {
  description = "Your student ID"
  type        = string
  default     = "alt-soe-025-5701"
}

variable "cluster_name" {
  description = "EKS cluster name. Must match exactly — the grader checks this."
  type        = string
  default     = "project-bedrock-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC. Must match exactly — the grader checks this."
  type        = string
  default     = "project-bedrock-vpc"
}# trigger CI

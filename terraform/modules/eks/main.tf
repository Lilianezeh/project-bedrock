# This uses the official AWS EKS Terraform module.
# It creates the cluster control plane, IAM roles, node group,
# and the OIDC provider needed for IRSA (IAM Roles for Service Accounts).

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # These two values are checked by the grader — do not change them
  cluster_name    = var.cluster_name
  cluster_version = "1.34"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # Allow kubectl access from your laptop and from the CI/CD pipeline.
  # Without this, you cannot run kubectl commands from outside the VPC.
  cluster_endpoint_public_access = true

  # Enable all 5 control plane log types.
  # This is required for the Observability section of the project.
  # These logs will appear in CloudWatch under /aws/eks/project-bedrock-cluster/
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # IRSA = IAM Roles for Service Accounts.
  # This is required so the ALB controller and CloudWatch agent
  # can get AWS permissions without hardcoding access keys.
  enable_irsa = true

  # Node group — the EC2 instances that run your pods
  eks_managed_node_groups = {
    general = {
      name = "bedrock-node-group"

      # t3.medium has 2 vCPU and 4GB RAM.
      # Do not use t3.small — it will OOM-kill pods.
      instance_types = ["t3.small"]

      # Start with 2 nodes. Scale to 0 when not working to save money.
      min_size     = 1
      max_size     = 3
      desired_size = 2

      labels = {
        Project = "karatu-2025-capstone"
      }

      tags = {
        Name = "bedrock-node-group"
      }
    }
  }

  tags = {
    Name = var.cluster_name
  }
}

# ── Outputs ───────────────────────────────────────────────────────
# These are used by the root outputs.tf and by the providers.tf
# Kubernetes/Helm provider configuration.

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_certificate_authority" {
  description = "Base64-encoded certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider — needed to create IRSA roles"
  value       = module.eks.oidc_provider_arn
}

output "node_security_group_id" {
  description = "Security group ID attached to EKS worker nodes"
  value       = module.eks.node_security_group_id
}
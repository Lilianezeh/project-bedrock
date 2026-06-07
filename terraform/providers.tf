terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# default_tags applies "Project: karatu-2025-capstone" to every
# AWS resource you create, automatically. No need to add tags manually.
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}

# The Kubernetes and Helm providers need to talk to your EKS cluster.
# They read the cluster endpoint and credentials from AWS after EKS is created.
# These two data sources look up your cluster after it exists.
data "aws_eks_cluster" "bedrock" {
  name       = var.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "bedrock" {
  name       = var.cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  host = data.aws_eks_cluster.bedrock.endpoint
  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.bedrock.certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.bedrock.token
}

provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.bedrock.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.bedrock.certificate_authority[0].data
    )
    token = data.aws_eks_cluster_auth.bedrock.token
  }
}
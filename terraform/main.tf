module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "rds" {
  source = "./modules/rds"

  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  eks_security_group_id = module.eks.node_security_group_id

  mysql_username = "bedrock_mysql_admin"
  mysql_password = "MySQL#Bedrock2026!Secure"

  pg_username = "bedrock_pg_admin"
  pg_password = "Postgres#Bedrock2026!Secure"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "serverless" {
  source     = "./modules/serverless"
  student_id = var.student_id
}
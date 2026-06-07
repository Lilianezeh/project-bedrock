data "aws_secretsmanager_secret" "mysql" {
  name = "bedrock/mysql/credentials"
}

data "aws_secretsmanager_secret_version" "mysql" {
  secret_id = data.aws_secretsmanager_secret.mysql.id
}

data "aws_secretsmanager_secret" "postgres" {
  name = "bedrock/postgres/credentials"
}

data "aws_secretsmanager_secret_version" "postgres" {
  secret_id = data.aws_secretsmanager_secret.postgres.id
}

resource "aws_db_subnet_group" "bedrock" {
  name       = "bedrock-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "bedrock-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier        = "bedrock-mysql"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "retail"
  username = jsondecode(data.aws_secretsmanager_secret_version.mysql.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.mysql.secret_string)["password"]

  db_subnet_group_name   = aws_db_subnet_group.bedrock.name
  vpc_security_group_ids = [var.eks_security_group_id]

  skip_final_snapshot = true
  publicly_accessible = false
}

resource "aws_db_instance" "postgres" {
  identifier        = "bedrock-postgres"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "retail_pg"
  username = jsondecode(data.aws_secretsmanager_secret_version.postgres.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.postgres.secret_string)["password"]

  db_subnet_group_name   = aws_db_subnet_group.bedrock.name
  vpc_security_group_ids = [var.eks_security_group_id]

  skip_final_snapshot = true
  publicly_accessible = false
}

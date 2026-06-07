# This security group controls who can connect to the RDS databases.
# It only allows traffic from within the VPC — meaning only the EKS
# nodes and pods can reach the databases. Nothing from the internet can.

resource "aws_security_group" "rds_sg" {
  name        = "bedrock-rds-sg"
  description = "Allow database traffic only from within the VPC"
  vpc_id      = module.vpc.vpc_id

  # Allow MySQL connections (port 3306) from anything inside the VPC
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "MySQL from VPC"
  }

  # Allow PostgreSQL connections (port 5432) from anything inside the VPC
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "PostgreSQL from VPC"
  }

  # Allow all outbound traffic (RDS needs this to respond to queries)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "bedrock-rds-sg"
  }
}

# ── Output ────────────────────────────────────────────────────────
# The RDS module needs this ID to attach the security group to the
# RDS instances it creates.

output "rds_security_group_id" {
  description = "Security group ID to attach to RDS instances"
  value       = aws_security_group.rds_sg.id
}
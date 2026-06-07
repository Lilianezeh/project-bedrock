variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "eks_security_group_id" {
  type = string
}

variable "mysql_username" {
  type = string
}

variable "mysql_password" {
  type = string
  sensitive = true
}

variable "pg_username" {
  type = string
}

variable "pg_password" {
  type = string
  sensitive = true
}
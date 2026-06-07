resource "aws_dynamodb_table" "retail_carts" {
  name         = "bedrock-retail-carts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "customerId"

  attribute {
    name = "customerId"
    type = "S"
  }

  tags = { Name = "bedrock-retail-carts" }
}

output "dynamodb_table_name" { value = aws_dynamodb_table.retail_carts.name }

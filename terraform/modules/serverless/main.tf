# ── S3 Assets Bucket ─────────────────────────────────────────────
resource "aws_s3_bucket" "assets" {
  bucket = "bedrock-assets-${var.student_id}"   # EXACT NAME — graded
  tags   = { Name = "bedrock-assets-${var.student_id}" }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket                  = aws_s3_bucket.assets.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id
  versioning_configuration { status = "Enabled" }
}

# ── IAM Role for Lambda ───────────────────────────────────────────
resource "aws_iam_role" "lambda_role" {
  name = "bedrock-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ── Package the Lambda zip ────────────────────────────────────────
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../../lambda/asset_processor.py"
  output_path = "${path.module}/lambda.zip"
}

# ── Lambda Function (EXACT NAME — graded) ────────────────────────
resource "aws_lambda_function" "asset_processor" {
  function_name    = "bedrock-asset-processor"
  role             = aws_iam_role.lambda_role.arn
  handler          = "asset_processor.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  tags             = { Name = "bedrock-asset-processor" }
}

# ── Allow S3 to invoke the Lambda ────────────────────────────────
resource "aws_lambda_permission" "s3_trigger" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

# ── S3 Event Notification → Lambda ───────────────────────────────
resource "aws_s3_bucket_notification" "lambda_trigger" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_trigger]
}

output "assets_bucket_name"   { value = aws_s3_bucket.assets.bucket }
output "lambda_function_name" { value = aws_lambda_function.asset_processor.function_name }
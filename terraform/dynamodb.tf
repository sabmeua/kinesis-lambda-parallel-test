resource "aws_dynamodb_table" "test_table" {
  name = "${var.app_name}_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "aws_request_id"

  attribute {
    name = "aws_request_id"
    type = "S"
  }
}

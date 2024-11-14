resource "aws_dynamodb_table" "counter" {
  name = "VisitorCounter"
  hash_key = "id"
  range_key    = "count"  
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "count"
    type = "N"
  }

  tags = {
    Name = "dynamo_db"
  }
}
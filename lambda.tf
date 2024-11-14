# Define the IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role_for_visitor_counter"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy_for_dynamo"
  role   = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "dynamodb:GetItem",   # Permission to read items from DynamoDB
          "dynamodb:PutItem",   # Permission to insert items into DynamoDB
          "dynamodb:Scan",      # Permission to scan DynamoDB tables
          "dynamodb:Query"      # Permission to query DynamoDB tables
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:*:*:table/*"  # Allows access to all tables in DynamoDB
      }
    ]
  })
}
resource "aws_lambda_permission" "apigateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.visitor_counter.function_name
}

resource "aws_lambda_function" "visitor_counter" {
  function_name = "visitor_counter_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "lambda_function.zip"  # The path to the Lambda zip file
  
  environment {
    variables = {
      DYNAMO_TABLE_NAME = aws_dynamodb_table.counter.name
    }
  }
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "count"
}

resource "aws_api_gateway_resource" "count" {
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "count"
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_method" "GET" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.count.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  http_method             = aws_api_gateway_method.GET.http_method
  resource_id             = aws_api_gateway_resource.count.id
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST" # Lambda integration method
  uri                     = aws_lambda_function.visitor_counter.invoke_arn
}

resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.count.id,
      aws_api_gateway_method.GET.id,
      aws_api_gateway_integration.lambda_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.deploy.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"
}

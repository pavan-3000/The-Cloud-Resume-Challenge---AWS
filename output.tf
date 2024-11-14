output "cloudfrontdns" {
  value = aws_cloudfront_distribution.s3_dist.domain_name
}


output "lambda_un" {
  value = aws_lambda_function.visitor_counter.arn
}


output "gateway" {
  value = aws_api_gateway_deployment.deploy.invoke_url
}
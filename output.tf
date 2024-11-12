output "cloudfrontdns" {
  value = aws_cloudfront_distribution.s3_dist.domain_name
}
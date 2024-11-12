# Local block for the S3 origin ID
locals {
  s3_origin_id = "mystaticresume"
}

# Define CloudFront Origin Access Control (OAC)
resource "aws_cloudfront_origin_access_control" "oac" {
  name                             = "my-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                 = "always"
  signing_protocol                 = "sigv4"
}

# Define CloudFront distribution
resource "aws_cloudfront_distribution" "s3_dist" {
  origin {
    domain_name               = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_access_control_id  = aws_cloudfront_origin_access_control.oac.id
    origin_id                 = local.s3_origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000
  }
  

  # Geo-restriction settings
  restrictions {
    geo_restriction {
      restriction_type = "none"
      
    }
  }

  # Optional: Viewer certificate for HTTPS
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
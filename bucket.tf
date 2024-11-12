resource "aws_s3_bucket" "bucket" {
  bucket = "pavan-resume-challange-pavansingh3000"
 
  tags  = {
    Name = "resume"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

}



resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "index.html"  # The name of the file in the S3 bucket
  source = "index.html"  # Path to your local file
  acl    = "private"
  content_type = "text/html"
}

# Upload another file (e.g., error.html)
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "style.css"
  source = "style.css"
  acl    = "private"
  content_type = "text/css"

}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*"
      }
    ]
  })
}

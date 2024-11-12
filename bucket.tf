resource "aws_s3" "bucket" {
  bucket = "pavan-resume-challange-pavansingh3000"

  tags  = {
    Name = "resume"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3.bucket.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

}
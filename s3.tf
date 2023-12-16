# WWW subdomain
resource "aws_s3_bucket" "website_subdomain" {
  bucket = "www.${var.bucket_name}"
}

resource "aws_s3_bucket_website_configuration" "website_subdomain" {
  bucket = aws_s3_bucket.website_subdomain.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website_subdomain" {
  bucket                  = aws_s3_bucket.website_subdomain.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_access_subdomain" {
  bucket = aws_s3_bucket.website_subdomain.id
  policy = data.aws_iam_policy_document.allow_public_access_subdomain.json
  depends_on = [
    aws_s3_bucket.website_subdomain,
    aws_s3_bucket_public_access_block.website_subdomain,
  ]
}

data "aws_iam_policy_document" "allow_public_access_subdomain" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.website_subdomain.arn}/*",
    ]
  }
}
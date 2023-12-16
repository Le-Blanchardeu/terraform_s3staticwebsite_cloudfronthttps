data "aws_cloudfront_cache_policy" "aws_caching_optimized" {
  name = "Managed-CachingOptimized"
}

# Cloudfront distribution for the subdomain (wwww)
resource "aws_cloudfront_origin_access_control" "website_subdomain" {
  name                              = "www.${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website_subdomain" {

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "www.${var.bucket_name}.s3-website-${var.aws_region}.amazonaws.com"
    origin_id           = "www.${var.bucket_name}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  http_version        = "http2and3"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_200"

  default_cache_behavior {
    cache_policy_id  = data.aws_cloudfront_cache_policy.aws_caching_optimized.id
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "www.${var.bucket_name}"

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
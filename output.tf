output "your_website_url" {
  value       = aws_cloudfront_distribution.website_subdomain.domain_name
  description = "Your static website url"
}
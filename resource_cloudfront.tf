resource "aws_cloudfront_distribution" "kittens-distribution" {
  origin {
    domain_name = aws_s3_bucket.kittens-bucket.bucket_regional_domain_name
    origin_id   = "S3Origin"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
      http_port              = 80
      https_port             = 443
    }
  }

  enabled             = true
  comment             = "Cloudfront Distribution pointing to Kittens S3 bucket"
  is_ipv6_enabled     = true
  http_version        = "http2"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "${var.domain}.s3.amazonaws.com"
    prefix          = "kittens-prefix"
  }

  aliases = [var.domain]

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https" # "allow-all"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3Origin"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_200" # "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }


  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:377346128947:certificate/3e3bdfc2-8331-4a00-a597-8e387888f704"
    ssl_support_method  = "sni-only"
  }
}


output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.kittens-distribution.domain_name
}

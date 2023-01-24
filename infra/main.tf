locals {
  origin_id = "verkkopalvelu.vrk.fi"
}

resource "aws_cloudfront_distribution" "this" {
  comment         = "CORS proxy for sukunimitin API access"
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2and3"
  price_class     = "PriceClass_100" # NA & EU

  origin {
    origin_id   = local.origin_id
    domain_name = "verkkopalvelu.vrk.fi"
    origin_path = "/nimipalvelu"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = local.origin_id
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "https-only"

    cache_policy_id            = data.aws_cloudfront_cache_policy.CachingDisabled.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.CORS-With-Preflight.id
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_cloudfront_cache_policy" "CachingDisabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_response_headers_policy" "CORS-With-Preflight" {
  name = "Managed-CORS-With-Preflight"
}

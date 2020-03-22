locals {
  default_name = "${var.project}-backend-${terraform.workspace}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.default_name
  acl    = "private"

  tags = {
    Project     = var.project
    Name        = "S3 Storage Bucket"
    Environment = terraform.workspace
  }
}

resource "random_string" "origin_id" {
  length  = 16
  special = false
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = random_string.origin_id.result
}

resource "aws_cloudfront_distribution" "cdn" {
  # Wait deploy
  wait_for_deployment = false

  # Default Origin
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = random_string.origin_id.result

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  # Default Cache
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = random_string.origin_id.result
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # Distribution Settings
  price_class = "PriceClass_All"
  aliases     = var.cdn_domain
  enabled     = true

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Tags
  tags = {
    Project     = var.project
    Name        = "Storage Cloudfront"
    Environment = terraform.workspace
  }
}

# Update bucket policy
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
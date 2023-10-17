// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "kittens-bucket" {
  bucket        = var.bucket-name
  force_destroy = true // Default:false,  Normally it must be false. Because if we delete s3 mistakenly, we loose all of the states.
}


// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.kittens-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "version_enable" {
  bucket = aws_s3_bucket.kittens-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_public_access_block" "blockkkk" {
  bucket                  = aws_s3_bucket.kittens-bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
// https://developer.hashicorp.com/terraform/language/functions/fileset
resource "aws_s3_object" "index" {     
  bucket = aws_s3_bucket.kittens-bucket.id
  key    = "index.html"
  source = "${path.module}/static-web/index.html"
  etag   = filemd5("${path.module}/static-web/index.html")
}

resource "aws_s3_object" "photos" {
  for_each = fileset("${path.module}/static-web/", "*.jpg") // * --> index.html + photos
  bucket   = aws_s3_bucket.kittens-bucket.id
  key      = each.value
  source   = "${path.module}/static-web/${each.value}"
  etag     = filemd5("${path.module}/static-web/${each.value}")
}


# S3 bucket policy-1
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.kittens-bucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  version = "2012-10-17"
  statement {
    actions = ["s3:GetObject"]
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "${aws_s3_bucket.kittens-bucket.arn}/*" // "arn:aws:s3:::${aws_s3_bucket.kittens-bucket.bucket}/*"
      //  "arn:aws:s3:::${aws_s3_bucket.kittens-bucket.id}/*"
    ]
  }
}

data "aws_canonical_user_id" "current" {}


resource "aws_s3_bucket_ownership_controls" "ownershipsss" {
  bucket = aws_s3_bucket.kittens-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.ownershipsss]

  bucket = aws_s3_bucket.kittens-bucket.id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}



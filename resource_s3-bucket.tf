resource "aws_s3_bucket" "kittens-bucket" {
  bucket = var.bucket-name
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.kittens-bucket.id
  key    = "index.html"
  source = "C:/Users/LEVENT/Desktop/Project-006-kittens-TERRAFOM/static-web/index.html"
  acl    = "public-read"
}

resource "aws_s3_object" "photos" {
  for_each = fileset("C:/Users/LEVENT/Desktop/Project-006-kittens-TERRAFOM/static-web/", "*")
  bucket   = aws_s3_bucket.kittens-bucket.id
  key      = each.value
  source   = "C:/Users/LEVENT/Desktop/Project-006-kittens-TERRAFOM/static-web/${each.value}"
  etag     = filemd5("C:/Users/LEVENT/Desktop/Project-006-kittens-TERRAFOM/static-web/${each.value}")
  acl      = "public-read" ####
}

resource "aws_s3_bucket_website_configuration" "kittens-websconfig" {
  bucket = aws_s3_bucket.kittens-bucket.id

  index_document {
    suffix = "index.html"
  }
}


# resource "aws_s3_bucket_policy" "kittens-policy" { ### AYDIN=> 2012-10-17  , "Principal" : {"AWS": "*"}
#   bucket = aws_s3_bucket.kittens-bucket.id
#   policy = <<POLICY
# {
#     "Version": "2012-10-17", 
#     "Statement": [
#         {
#             "Sid"       : "AllowEveryoneReadOnlyAccess",
#             "Effect"    : "Allow",
#             "Principal" : "*" ,
#             "Action"    : [ "s3:GetObject" ],
#             "Resource"  : [ "arn:aws:s3:::${aws_s3_bucket.kittens-bucket.bucket}/*" ]
#         }
#     ]
# }
# POLICY
# }



resource "aws_s3_bucket_policy" "bucket_policy" { ###
  bucket = aws_s3_bucket.kittens-bucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {
    actions = ["s3:GetObject"]
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.kittens-bucket.bucket}/*",
    ]
  }
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.kittens-bucket.id
  acl    = "public-read"
}




output "kittens_bucket_website-name" {
  value = "http://${aws_s3_bucket.kittens-bucket.id}.s3-website-us-east-1.amazonaws.com"
}

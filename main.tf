resource "aws_s3_bucket" "fullstack" {
  bucket        = "fullstack-labs-s3-${var.env_tf}"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "fullstack_versioning" {
  bucket = aws_s3_bucket.fullstack.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "fullstack_website_enable" {
  bucket = aws_s3_bucket.fullstack.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "fullstack_public_access" {
  bucket = aws_s3_bucket.fullstack.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "fullstack_allow_public_access" {
  bucket = aws_s3_bucket.fullstack.id
  policy = data.aws_iam_policy_document.fullstack_allow_public_access_policy.json
}

data "aws_iam_policy_document" "fullstack_allow_public_access_policy" {
  statement {
    sid = "PublicReadGetObject"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.fullstack.arn}/*",
    ]
  }
}

# Sync Content
resource "aws_s3_bucket_object" "object" {
  for_each = fileset("build/", "**/*.*")
  bucket   = aws_s3_bucket.fullstack.id
  key      = each.value
  source   = "build/${each.value}"
}
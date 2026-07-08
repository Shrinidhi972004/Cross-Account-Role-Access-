data "aws_iam_policy_document" "cross_account_permissions" {
  statement {
    sid    = "S3ReadOnlyScoped"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "cross_account_permissions" {
  name        = var.cross_account_permissions_policy_name
  description = "Read-only scoped access for cross-account validation"
  policy      = data.aws_iam_policy_document.cross_account_permissions.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.cross_account_permissions.arn
}
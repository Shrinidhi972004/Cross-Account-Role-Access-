data "aws_iam_policy_document" "role_boundary" {
  statement {
    sid       = "BoundaryAllowsLogsOnly"
    effect    = "Allow"
    actions   = ["logs:DescribeLogGroups"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "role_boundary" {
  name        = var.permissions_boundary_name
  description = var.permissions_boundary_description
  policy      = data.aws_iam_policy_document.role_boundary.json
}
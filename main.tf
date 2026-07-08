terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

data "aws_iam_policy_document" "cross_account_trust" {
    statement {
        effect = "Allow"
        principals {
            type = "AWS"
            identifiers = [var.source_iam_user_arn]
        }
        actions = ["sts:AssumeRole"]
        condition {
            test = "StringEquals"
            variable = "sts:ExternalId"
            values = [var.external_id]
        }
    }
}

resource "aws_iam_role" "cross_account_role" {
    name = var.cross_account_role_name
    assume_role_policy = data.aws_iam_policy_document.cross_account_trust.json
    description = "${var.cross_account_role_description} (source account ${var.source_account_id})"
    max_session_duration = 3600
    permissions_boundary = aws_iam_policy.role_boundary.arn
}
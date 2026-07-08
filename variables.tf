variable "aws_region" {
  description = "AWS region for the target account"
  type        = string
  default     = "ap-south-1"
}

variable "cross_account_role_name" {
  description = "Name of the IAM role to create"
  type        = string
  default     = "cross-account-week5-role"
}

variable "cross_account_role_description" {
  description = "Description for the IAM role"
  type        = string
  default     = "Allows a source IAM user to assume this role for Week 5 cross-account activity"
}

variable "source_iam_user_arn" {
  description = "IAM user ARN allowed to assume the role"
  type        = string
  default     = "arn:aws:iam::123456789012:user/replace-me"
}

variable "source_account_id" {
  description = "Source AWS account ID"
  type        = string
  default     = "123456789012"
}

variable "external_id" {
  description = "External ID required to assume the role"
  type        = string
  default     = "replace-me"
}

variable "s3_bucket_name" {
  description = "Bucket name used by the permission policy"
  type        = string
  default     = "example-terraform-state-bucket"
}

variable "cross_account_permissions_policy_name" {
  description = "Name of the IAM policy resource"
  type        = string
  default     = "cross-account-week5-permissions"
}

variable "permissions_boundary_name" {
  description = "Name of the permission boundary policy"
  type        = string
  default     = "cross-account-week5-boundary"
}

variable "permissions_boundary_description" {
  description = "Description for the permission boundary policy"
  type        = string
  default     = "Permission boundary capping the cross-account role to logs:DescribeLogGroups only"
}
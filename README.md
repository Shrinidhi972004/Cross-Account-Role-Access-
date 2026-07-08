# Cross-Account IAM Role Access

Terraform project demonstrating secure cross-account IAM role access between two independent AWS accounts, using a scoped trust policy, an External ID condition, and a least-privilege permission policy. Built as part of a Week 5 CloudOps IAM training activity.

## Overview

This project provisions an IAM role in a target account that can only be assumed by a specific IAM user in a source account. The role grants read-only access to a single S3 bucket, and all access boundaries are validated using the AWS CLI from both accounts.

- Target account: replace with your target AWS account ID
- Source account: replace with your source AWS account ID

## Architecture

Account B (Source)                Account A (Target)
IAM User: replace-me  --assume-role + ExternalId-->  IAM Role: cross-account-week5-role
                                                 - Trust Policy (only the configured IAM user can assume)
                                                 - Permission Policy (S3 read-only, scoped)

## Prerequisites

- Terraform >= 1.9
- AWS CLI configured with credentials for the target account
- A second AWS account with an IAM user that has sts:AssumeRole permission (or AdministratorAccess)
- The exact IAM user ARN from the source account (obtained via aws sts get-caller-identity)

## Project Structure

.
├── main.tf         (Provider config + IAM role + trust policy)
├── permissions.tf  (Permission policy + policy attachment)
├── outputs.tf      (Role ARN output)
└── README.md



## Usage

### 1. Deploy the role (Target Account)

terraform init
terraform plan
terraform apply

Expected: 3 resources created (IAM role, IAM policy, policy attachment). The role ARN is printed as output.

### 2. Assume the role (Source Account)

From the source account, run:

aws sts assume-role \
  --role-arn arn:aws:iam::REPLACE_WITH_TARGET_ACCOUNT_ID:role/cross-account-week5-role \
  --role-session-name cross-account-test \
  --external-id replace-me

Export the returned temporary credentials:

export AWS_ACCESS_KEY_ID=<AccessKeyId>
export AWS_SECRET_ACCESS_KEY=<SecretAccessKey>
export AWS_SESSION_TOKEN=<SessionToken>

### 3. Validate identity

aws sts get-caller-identity

Expected output:

{
    "UserId": "AROAQETILPT43RKU6BJYF:cross-account-test",
    "Account": "REPLACE_WITH_TARGET_ACCOUNT_ID",
    "Arn": "arn:aws:sts::REPLACE_WITH_TARGET_ACCOUNT_ID:assumed-role/cross-account-week5-role/cross-account-test"
}

### 4. Validate access boundaries

# Should SUCCEED — scoped bucket read access
aws s3 ls s3://REPLACE_WITH_BUCKET_NAME/

# Should FAIL — account-wide bucket listing not granted
aws s3 ls

# Should FAIL — no EC2 permissions granted
aws ec2 describe-instances

## Validation Results

Test: Role assumption identity | Command: aws sts get-caller-identity | Expected: Assumed-role ARN | Result: Confirmed
Test: Scoped S3 read access | Command: aws s3 ls s3://REPLACE_WITH_BUCKET_NAME/ | Expected: Allowed | Result: Succeeded
Test: Account-wide S3 listing | Command: aws s3 ls | Expected: Denied | Result: AccessDenied
Test: Unrelated service access | Command: aws ec2 describe-instances | Expected: Denied | Result: UnauthorizedOperation

## Cleanup

terraform destroy

## Security Notes

- Trust policy scopes assumption to a single named IAM user ARN, not the entire source account root.
- An sts:ExternalId condition is enforced to mitigate confused-deputy risk.
- Permission policy grants only s3:GetObject and s3:ListBucket, scoped to one bucket ARN — no wildcard resources.
- Temporary credentials from sts:assume-role expire automatically (max session duration: 3600 seconds); no long-lived keys are involved in this flow.
- Never commit AWS access keys, secret keys, or session tokens to version control. This repository contains only Terraform configuration — no credentials.

## License

Internal training project — not intended for production use as-is. Bucket names, account IDs, and role names should be parameterized before reuse.
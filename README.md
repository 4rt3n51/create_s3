# Authors

Artenis Islami
Fiona Metaj
Kei Paravani
Mario Leka

# S3 Bucket Terraform Project

This repository provisions a secure Amazon S3 bucket using Terraform. It includes a reusable module for bucket creation and a sample root configuration that wires the module with AWS provider settings and common variables.

## Repository structure

- `infra/` – root Terraform configuration that calls the module
- `module/` – reusable S3 bucket module

## What this project creates

The module provisions:

- An S3 bucket with a generated unique name
- Optional versioning
- KMS-based encryption
- Lifecycle rules for transition and expiration
- Server access logging and optional CloudTrail logging
- Public access blocking
- Bucket policy requiring secure transport (`HTTPS` only)
- IAM roles and policies for read, write, and operator access

## Prerequisites

Before running Terraform, make sure you have:

- Terraform v1.3.0 or later
- AWS CLI configured with valid credentials
- Permission to create S3 buckets, IAM roles, policies, and CloudTrail resources in the target AWS account

## AWS provider configuration

The root configuration sets the AWS region in [infra/provider.tf](infra/provider.tf):

```hcl
provider "aws" {
  region = var.region
}
```

Default region:

```hcl
variable "region" {
  description = "AWS region where the bucket will be created."
  type        = string
  default     = "eu-central-1"
}
```

## Usage

From the `infra/` folder, initialize and apply the configuration:

```bash
terraform init
terraform plan
terraform apply
```

Example configuration:

```hcl
module "s3_bucket" {
  source = "../module"

  bucket_name     = "example-data"
  region          = "eu-central-1"
  enable_versioning = true
  encryption_type = "aws:kms"
  enable_logging  = "both"

  tags = {
    Environment = "dev"
    Project     = "analytics"
    Owner       = "platform"
  }
}
```

## Module inputs

The module supports the following important inputs:

- `bucket_name` – base bucket name; the module normalizes and appends a timestamp/unique suffix
- `versioning` – enables or disables S3 versioning
- `encryption_type` – `aws:kms` or other supported S3 encryption mode
- `kms_key_arn` – optional KMS key ARN
- `lifecycle_rules` – lifecycle transitions and expirations
- `enable_logging` – values: `"server-access-logging"`, `"cloudtrail-logging"`, `"both"`, or empty string to disable
- `tags` – bucket tags

## Example variables

A simple values example:

```hcl
region = "eu-central-1"
bucket_name = "finance-reports"
enable_versioning = true
encryption_type = "aws:kms"
enable_logging = "both"

tags = {
  Environment = "prod"
  Team        = "platform"
}
```

## Outputs

The root module exposes the following outputs:

- `bucket_name`
- `bucket_arn`
- `logs_bucket_name`
- `cloudtrail_name`

These are defined in [infra/outputs.tf](infra/outputs.tf).

## Security notes

This setup enforces several secure defaults:

- public access is blocked
- only HTTPS is allowed for bucket access
- default encryption is enabled
- versioning is enabled by default
- logging is available via S3 access logs and/or CloudTrail

## Important considerations

- Bucket names must be globally unique across AWS.
- The module adds a date-based suffix to the base name to reduce naming collisions.
- CloudTrail logging requires valid AWS permissions and appropriate service access.
- If you use custom KMS keys, ensure the key ARN is valid and the right IAM permissions are in place.
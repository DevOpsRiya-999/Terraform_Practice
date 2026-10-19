
# TerraWeek Day 6 — Terraform Capstone

## Overview
An AWS infrastructure project built using Terraform.
It demonstrates reusable modules, remote state, native
locking, workspace-based configuration, testing, security
scanning and GitHub Actions CI.

## Architecture
- AWS VPC created with the official Registry module
- Public subnet for an Ubuntu EC2 web server
- Custom module for EC2 and its security group
- Nginx installed through EC2 user data
- S3 remote Terraform state with native lock files

## Prerequisites
- Terraform >= 1.10
- AWS CLI and authorized AWS credentials
- An S3 state bucket configured with versioning
- Trivy
- Git and GitHub

## Setup
1. Configure AWS credentials.
2. Create the remote state bucket separately.
3. Update backend.tf with the bucket name and region.
4. Initialize Terraform:

   terraform init

5. Format and validate:

   terraform fmt -recursive
   terraform validate

6. Run tests and security checks:

   terraform test
   trivy config .

7. Review and deploy:

   terraform plan
   terraform apply

8. Check outputs:

   terraform output

## Cleanup
Run terraform plan -destroy, review the plan,
and run terraform destroy when finished.

## CI/CD
GitHub Actions checks formatting, validation, tests,
security findings and the Terraform execution plan.

## Lessons learned
- Terraform workspaces maintain separate state.
- Modules make infrastructure reusable.
- Remote state supports safer team collaboration.
- Tests and security checks catch issues earlier.
- Plans should be reviewed before applying changes.

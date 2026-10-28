# 🏁 TerraWeek Day 7 — Wrap Up & Review


## 📌 Overview

Day 7 is the final day of the TerraWeek Terraform Challenge. After six days of learning and hands-on practice, today's goal is to review all the concepts, organize the GitHub repository, verify security best practices, and clean up cloud resources.

There is no new Terraform concept to learn today. The main objective is to make sure the work completed during the challenge is organized, secure, and ready to showcase as a portfolio project.

## 🎯 Objectives

- Review the work completed from Day 1 to Day 6.
- Organize Terraform code in a GitHub repository.
- Document the capstone project.
- Check that secrets and Terraform state files are not committed.
- Destroy unnecessary cloud infrastructure to avoid unexpected costs.
- Revise important Terraform commands and concepts.
- Identify areas that need more practice.

## 📂 1. GitHub Repository Review

Before completing the challenge, verify that the repository contains all the required files.

### Checklist

- [ ] GitHub repository created for TerraWeek.
- [ ] Day 1 to Day 6 code organized into folders.
- [ ] Day 6 capstone project includes a `README.md`.
- [ ] Architecture and infrastructure details documented.
- [ ] Top-level `README.md` explains the complete project.
- [ ] `.gitignore` excludes sensitive files.
- [ ] No AWS credentials, secrets, or sensitive `.tfvars` files committed.
- [ ] No Terraform state files committed.
- [ ] Unnecessary AWS resources destroyed.

### Example Repository Structure

```text
TerraWeek/
├── README.md
├── .gitignore
├── day-1/
│   └── README.md
├── day-2/
│   └── README.md
├── day-3/
│   └── README.md
├── day-4/
│   └── README.md
├── day-5/
│   └── README.md
├── day-6-capstone/
│   ├── README.md
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   ├── modules/
│   ├── tests/
│   └── .github/
│       └── workflows/
│           └── terraform.yml
└── day-7/
    └── README.md
```



## 🔐 2. Terraform Security Review

Terraform projects can contain sensitive information, so security must be checked before pushing code to GitHub.

### Important files to exclude

- `*.tfstate`
- `*.tfstate.*`
- `*.tfvars`
- `*.tfvars.json`
- `.terraform/`
- `crash.log`
- Local secret or credential files

### Example `.gitignore`

```gitignore
# Terraform working directory
.terraform/

# Terraform state files
*.tfstate
*.tfstate.*

# Variable files that may contain secrets
*.tfvars
*.tfvars.json

# Crash logs
crash.log
crash.*.log

# Local override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# CLI configuration
.terraformrc
terraform.rc

# Environment files
.env
.env.*

# Sensitive keys
*.pem
*.key
```

**Important:** Do not ignore every `.tfvars` file blindly if your project intentionally tracks a safe example file. You can commit `terraform.tfvars.example` containing placeholder values, but never commit real credentials or secrets.

If a secret has already been committed, removing it from the latest commit is not enough. Rotate or revoke the exposed credential and clean the repository history if necessary.

## 🧠 3. Revise the Terraform Workflow

The basic Terraform workflow is:

### Step 1: Initialize

```bash
terraform init
```

Downloads required providers, initializes the working directory, and configures the backend.

### Step 2: Validate

```bash
terraform validate
```

Checks Terraform configuration syntax and internal consistency.

### Step 3: Review the execution plan

```bash
terraform plan
```

Shows the proposed infrastructure changes before they are applied.

### Step 4: Create or update infrastructure

```bash
terraform apply
```

Applies the planned changes after approval.

### Step 5: Destroy infrastructure

```bash
terraform destroy
```

Plans and removes the resources managed by the current Terraform configuration.

**Best practice:** Always review the proposed changes before approving `terraform apply` or `terraform destroy`. Confirm that the correct AWS account, region, workspace, and backend are selected.

## 🗂️ 4. Understand Terraform State

Terraform state maps the resources declared in your configuration to the real infrastructure Terraform manages.

### Why is state important?

- Tracks resource IDs and infrastructure attributes.
- Helps Terraform identify changes.
- Supports dependency management.
- Helps determine which resources need to be created, updated, or destroyed.

### Why use remote state?

A remote backend allows a team to access shared state from a central location rather than relying on one developer's local state file.

For an AWS S3 backend, important considerations include:

- Enable appropriate bucket access controls.
- Enable encryption.
- Enable versioning to help recover earlier state versions.
- Use least-privilege IAM permissions.
- Configure state locking to avoid conflicting changes.

Modern Terraform S3 backends support native lock files through the `use_lockfile` option when configured appropriately.

**Remember:** Terraform state can contain sensitive values. Remote storage improves collaboration but does not automatically make state secure.

## 📦 5. Understand Terraform Modules

A module is a reusable collection of Terraform configuration files that manages related infrastructure.

For example, a web server module might contain:

```text
modules/
└── web-server/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

A root configuration can call the module:

```hcl
module "web_server" {
  source = "./modules/web-server"

  # Add the input variables required by your module.
}
```

### Benefits of modules

- Reduce repeated configuration.
- Improve code organization.
- Make infrastructure reusable.
- Simplify maintenance.
- Support consistent infrastructure deployments.

**Revision question:** If you need to create the same type of web server in multiple environments, how could you reuse a module instead of copying the same configuration?

## 🧪 6. Review Testing and CI/CD

Terraform testing and CI/CD help identify problems before infrastructure changes reach production.

Review these commands and concepts:

```bash
terraform fmt -check -recursive
terraform validate
terraform plan
terraform test
```

- `terraform fmt -check -recursive`: Checks whether Terraform files follow the standard formatting.
- `terraform validate`: Checks configuration syntax and consistency.
- `terraform plan`: Previews infrastructure changes.
- `terraform test`: Runs Terraform tests defined in test files.

A GitHub Actions workflow can automate formatting checks, validation, security scanning, testing, and planning.

### Security tools

A tool such as Trivy can scan Terraform configuration for security misconfigurations. Review critical findings and fix issues before deployment.

For AWS authentication in GitHub Actions, prefer OIDC with an appropriately restricted IAM role instead of long-lived access keys whenever possible.

## 💸 7. AWS Resource Cleanup

One of the most important tasks is confirming that test infrastructure has been removed when it is no longer required.

From the appropriate Terraform project directory, inspect the workspace and backend before running:

```bash
terraform plan
terraform destroy
```

Then verify the result in the AWS Console or through the relevant AWS CLI commands.

### Cleanup checklist

- [ ] EC2 instances no longer needed are terminated.
- [ ] Unused EBS volumes and snapshots are reviewed.
- [ ] Unused Elastic IP addresses are released.
- [ ] NAT Gateways and other billable networking resources are checked.
- [ ] Unused load balancers and related resources are removed.
- [ ] S3 buckets are checked for stored data and ongoing costs.
- [ ] No unexpected resources remain in the AWS account.

**Important:** `terraform destroy` removes resources managed by that Terraform configuration. It does not automatically remove every resource in your AWS account. Check resources created manually, shared resources, and resources managed by other Terraform states separately. Never delete a shared resource without confirming its ownership and impact.


### My Learning Reflection

- **Most interesting topic:** Terraform modules and reusable infrastructure.
- **Most challenging topic:** Remote state, testing, and CI/CD integration.
- **Most important lesson:** Infrastructure automation requires security, testing, and careful state management, not just writing Terraform code.
- **Next improvement:** Rebuild the most challenging task from scratch and document the troubleshooting steps.

*Update these reflection points to match your actual experience during TerraWeek.*

## 🚀 9. What's Next?

After completing TerraWeek, continue learning and improving your Terraform skills.

- **HCP Terraform:** Explore collaborative infrastructure workflows and remote operations.
- **Terragrunt:** Learn techniques for managing larger Terraform configurations.
- **Policy as Code:** Explore Open Policy Agent (OPA) and Sentinel.
- **Multi-cloud:** Practice provisioning resources across different cloud providers.
- **Portfolio development:** Improve the capstone README, architecture diagram, security documentation, and deployment instructions.
- **Open source:** Contribute useful fixes or examples to community repositories through pull requests.

## 🏆 Final Takeaway

TerraWeek helped me understand how Terraform can be used to provision, organize, test, secure, and manage cloud infrastructure.

The most valuable lesson is that writing Terraform code is only one part of Infrastructure as Code. A good DevOps engineer must also understand state management, reusable modules, testing, CI/CD, security, troubleshooting, and cost optimization.

Completing the challenge is a starting point, not the finish line. The next step is to keep practising, improve the capstone project, and apply these concepts to real-world infrastructure.

### 🎉 TerraWeek Day 7 Completed!

**Challenge:** TerraWeek Terraform Challenge
**Hashtags:** #TrainWithShubham #TerraWeekChallenge #Terraform #AWS #DevOps #InfrastructureAsCode

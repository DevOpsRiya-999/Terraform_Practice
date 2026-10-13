
# 🚀 TerraWeek Day 3: Providers, Resources & Your First Cloud Infrastructure

📅 **Date:** 13 October 2026  
☁️ **Cloud Provider:** AWS  
🎯 **Challenge:** TerraWeek — Day 3

## 📌 Today's Learning Goals

- Understand Terraform providers and version pinning.
- Learn the difference between resources and data sources.
- Create AWS infrastructure using Terraform.
- Understand `count`, `for_each`, `depends_on`, and `lifecycle`.
- Practice planning, updating, and destroying infrastructure.

---

## 1. Terraform Provider & Version Pinning

A **provider** is a plugin that allows Terraform to communicate with a platform such as AWS, Azure, or Docker.

### Example: `versions.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
```

### Why pin provider versions?

- Makes Terraform runs more predictable.
- Helps avoid unexpected changes after provider upgrades.
- Records the selected version in `.terraform.lock.hcl`.

**What does `~> 6.0` mean?**

It allows compatible AWS provider versions from `6.0.0` up to, but not including, `7.0.0`.

### AWS authentication

Configure credentials using the AWS CLI:

```bash
aws configure
aws sts get-caller-identity
```

Never hard-code AWS access keys in Terraform files or commit them to GitHub.

---

## 2. Resources vs Data Sources

| Resources | Data Sources |
|---|---|
| Create and manage infrastructure. | Read information about existing infrastructure. |
| Example: `aws_instance` | Example: `aws_ami` |
| Terraform manages their lifecycle. | Terraform queries information for use in configuration. |

### Resource example

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

This creates a new VPC.

### Data source example

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

This reads the available AWS Availability Zones.

### Read the latest Amazon Linux 2023 AMI

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

Use it in an EC2 resource:

```hcl
ami = data.aws_ami.amazon_linux.id
```

---

## 3. AWS Networking Basics

| Component | Purpose |
|---|---|
| VPC | Isolated virtual network in AWS. |
| Subnet | Smaller IP range inside a VPC. |
| Internet Gateway | Connects a VPC to the internet. |
| Route Table | Controls where network traffic is sent. |
| Security Group | Stateful virtual firewall for resources. |
| EC2 | Virtual server in AWS. |

### Basic architecture

```text
Internet
   |
Internet Gateway
   |
Route Table
   |
Public Subnet
   |
Security Group
   |
EC2 Instance
```

The subnet must have a route to the Internet Gateway for internet access. An instance also needs a public IP and suitable security group rules for public inbound access.

---

## 4. Common Terraform Workflow

Run these commands from your Terraform project directory:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform state list
terraform output
terraform destroy
```

| Command | Purpose |
|---|---|
| `terraform init` | Downloads providers and initializes the project. |
| `terraform fmt` | Formats Terraform files. |
| `terraform validate` | Checks configuration syntax and consistency. |
| `terraform plan` | Previews proposed changes. |
| `terraform apply` | Applies the changes after confirmation. |
| `terraform state list` | Lists resources tracked in state. |
| `terraform output` | Displays configured outputs. |
| `terraform destroy` | Plans and removes managed infrastructure after confirmation. |

**Important:** Always review `terraform plan` before applying changes.

---

## 5. Terraform Meta-Arguments

Meta-arguments control how Terraform creates, orders, or updates resources.

### A. `count`

Creates multiple instances of a resource.

```hcl
resource "terraform_data" "demo" {
  count = 3

  input = "demo-${count.index}"
}
```

Addresses: `terraform_data.demo[0]`, `[1]`, `[2]`.

**Use when:** Resources are interchangeable.

### B. `for_each`

Creates instances from a map or set.

```hcl
resource "terraform_data" "environment" {
  for_each = toset(["dev", "test", "prod"])

  input = each.key
}
```

Addresses include:

- `terraform_data.environment["dev"]`
- `terraform_data.environment["test"]`
- `terraform_data.environment["prod"]`

**Use when:** Each resource has a meaningful, stable identity.

### `count` vs `for_each`

| `count` | `for_each` |
|---|---|
| Uses numeric indexes. | Uses map keys or set values. |
| Good for identical resources. | Good for named resources. |
| Removing an item can shift indexes. | Removing a key generally preserves other keys. |

### C. `depends_on`

Specifies an explicit dependency.

```hcl
resource "terraform_data" "first" {
  input = "First"
}

resource "terraform_data" "second" {
  input      = "Second"
  depends_on = [terraform_data.first]
}
```

Terraform creates `first` before `second`.

Use `depends_on` only when Terraform cannot infer a required dependency from normal resource references.

### D. `lifecycle`

Controls resource replacement and update behavior.

```hcl
resource "terraform_data" "example" {
  input = "TerraWeek"

  lifecycle {
    create_before_destroy = true
  }
}
```

Important lifecycle options:

- `create_before_destroy`: creates a replacement first when possible.
- `prevent_destroy`: rejects plans that destroy the resource while this rule remains configured.
- `ignore_changes`: ignores selected attributes when planning updates.
- `replace_triggered_by`: replaces a resource when specified resources or attributes change.

Example for ignoring a tag on an EC2 instance:

```hcl
lifecycle {
  ignore_changes = [tags["LastModified"]]
}
```

Place this inside the appropriate resource block. Use `ignore_changes` only when that attribute is intentionally managed elsewhere.

---

## 6. Updating Infrastructure

Change a configurable value, such as the EC2 instance type:

```hcl
instance_type = "t3.micro"
```

Then preview the change:

```bash
terraform plan
```

Review the output to determine whether Terraform plans an in-place update or replacement.

Apply only after reviewing the plan:

```bash
terraform apply
```

A tag change commonly results in an in-place update, while changing an AMI commonly requires replacing an EC2 instance. The actual plan is the source of truth.

---

## 7. Terraform Outputs

Create an `outputs.tf` file:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "website_url" {
  value = "http://${aws_instance.web.public_ip}"
}
```

After a successful apply:

```bash
terraform output
terraform output ec2_public_ip
```

Outputs help you retrieve important values without manually searching in the AWS Console.

---

## 8. Bonus Tasks

### Use a second provider alias

```hcl
provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}
```

Select it on a resource with:

```hcl
provider = aws.singapore
```

**Use case:** Managing resources in different AWS regions from one Terraform configuration.

### Visualize the dependency graph

```bash
terraform graph
```

This prints a graph in DOT format. You can save it for visualization:

```bash
terraform graph > graph.dot
```

### Rename a resource without recreating it

Terraform's `moved` block can update a resource's address in state:

```hcl
moved {
  from = terraform_data.old_name
  to   = terraform_data.new_name
}
```

Update the resource block name to match the destination address before applying.

---

## 9. Cleanup — Avoid Surprise Bills

When you finish testing:

```bash
terraform plan
terraform destroy
```

Review the proposed deletions and confirm with `yes` only when you're ready.

Check the AWS Console for leftover resources. Destroy removes resources managed by the configuration; it does not automatically remove unrelated resources.

**Cost reminder:** Check current AWS pricing and Free Tier eligibility. EC2 instances, public IPv4 addresses, and other resources may incur charges.

---

## 🧠 Key Learnings

- Providers connect Terraform to cloud platforms.
- Version pinning makes provider behavior more predictable.
- Resources create and manage infrastructure; data sources read existing information.
- VPCs, subnets, route tables, gateways, and security groups work together to provide network connectivity.
- `count` is useful for interchangeable resources; `for_each` is useful for named resources.
- `depends_on` establishes explicit ordering when needed.
- `lifecycle` controls selected update and replacement behavior.
- `terraform plan` helps review changes before applying them.
- Always clean up test infrastructure when finished.

---

## 📤 Day 3 Completion Checklist

- [ ] Configured the AWS provider and version constraints.
- [ ] Used at least one data source.
- [ ] Created a VPC, public subnet, Internet Gateway, route table, security group, and EC2 instance.
- [ ] Practiced `terraform init`, `fmt`, `validate`, `plan`, and `apply`.
- [ ] Inspected resources with `terraform state list`.
- [ ] Practiced `count`, `for_each`, `depends_on`, and `lifecycle`.
- [ ] Changed configuration and reviewed the plan.
- [ ] Destroyed test infrastructure and checked for leftover resources.
- [ ] Pushed Day 3 notes and evidence to GitHub.

---

## 🙌 Challenge Notes

**Challenge:** TerraWeek Day 3  
**Topic:** Providers, Resources & Your First Cloud Infrastructure  
**Cloud:** AWS  
**Hashtags:** #TerraWeek #TerraWeekChallenge #TrainWithShubham #Terraform #AWS #DevOps #IaC #LearningInPublic

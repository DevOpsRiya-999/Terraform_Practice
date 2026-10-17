# Task 1: Modules — the Why
1> What is a module? What counts as the root module?
>>A Terraform module is a collection of standard Terraform configuration files (.tf) grouped together in a single directory.
>>They function like reusable, self-contained building blocks—similar to functions or libraries in programming
Imagine you need to create three EC2 instances:
- An application server
- A worker server
- A cache server
Without modules, you might write the same EC2 resource configuration three times and change only the names.
With modules, you write the EC2 configuration once and reuse it for all three servers.
* Root module vs. child module
  
🔄 Root Modules vs. Child Modules

Terraform organizes infrastructure hierarchically:
• Root Module: The main working directory where you run commands like terraform apply. Every Terraform configuration has at least one root module.
* Child Module: Any external module that is called from within your root module using a module block

🌟 Key Benefits

• Code Reusability & DRY: Follows the "Don't Repeat Yourself" (DRY) principle. You can provision dev, staging, and production environments using the same blueprint.
• Encapsulation: Resources inside a module are isolated. The rest of your configuration doesn't need to know the inner complexities; it just interacts with the inputs and outputs.
• Standardization & Security: Teams can build standardized modules that enforce security rules, proper resource tagging, and organizational compliance by default.
• Remote Distribution: Modules can be hosted locally or sourced remotely from version control systems (like GitHub), cloud storage buckets, or the public HCP Terraform
 ### What files make up a well-structured module (main.tf, variables.tf, outputs.tf, README.md)?
```bash
example/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── modules/
    └── ec2_instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```
* 1. What is locals in Terraform?
locals lets you create a named value from existing values or expressions and reuse it in your configuration.
Think of it like a small box where you store a value and give it a meaningful name.
```bash
locals {
  subnet_id          = data.aws_subnets.default.ids[0]
  security_group_ids = [data.aws_security_group.default.id]
}
```
You are creating two local values:
- subnet_id — stores the ID of one subnet.
- security_group_ids — stores the security group ID inside a list.
- One technical clarification: locals do not perform the AWS lookup themselves. Your data blocks perform the lookups; the locals block stores or transforms their results.
- The data sources are declared once in the root module, rather than repeated in each child module.
  
 ### Remember this simple rule:
- var. → input variables
- local. → local values
- data. → information looked up from an existing resource or service
🔧 5. Create a Reusable EC2 Module

The child module will create an EC2 instance using values supplied by the root module.

File 1: modules/ec2_instance/variables.tf
Important concepts

variable defines an input.

type = string means the input expects text.

type = list(string) means a list of text values.

default supplies a value when the caller does not provide one.

description documents the purpose of an input.

Remember: Variables are the inputs of a module.

🌳 6. Call the Child Module from the Root Module

File 4: Root main.tf

This example assumes that a suitable VPC, subnet, and security group already exist in your AWS account.

Replace all placeholder IDs with valid IDs from the same AWS region.
Explanation of the module block

module "web_server" gives the module instance its name.

source identifies the local child module directory.

name, instance_type, and environment are inputs.

ami, subnet_id, and vpc_security_group_ids provide the required AWS resource settings.

The source path is relative to the root module directory.
----------------
🔁 8. Use for_each to Create Multiple Servers

Instead of writing separate module blocks for three servers, we can reuse one module block.

Add the following to the root module:
What does for_each do?

toset() converts the list into a set of unique strings.

for_each creates one module instance for each set member.

each.key refers to the current member.
Here:

each.key provides the server name.

each.value provides the instance type.

Important: If both module "web_server" and module "servers" are enabled in the same configuration, Terraform plans four EC2 instances. Keep only the module blocks you intend to deploy.
🌐 9. Use a Terraform Registry Module

The Terraform Registry provides reusable modules published by HashiCorp and the wider community.

Example: the popular AWS VPC module.

Documentation:

https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

Example VPC configuration

Use this as a separate practice project.
Important points

source identifies the Registry module.

version restricts the acceptable module versions.

cidr defines the VPC IP address range.

public_subnets and private_subnets define subnet CIDR ranges.

module.vpc.vpc_id reads the VPC ID returned by the module.

This configuration disables NAT gateways to avoid their ongoing hourly charges. Other resources can still incur charges, and private subnets won't have internet access through a NAT gateway unless another suitable egress path exists.

Always check the selected module version's documentation before applying.
🔒 10. Module Version Pinning

Version pinning controls which versions or source revisions Terraform can use.

Pinning improves reproducibility and reduces the risk of unexpected changes when a module is updated.

A. Registry module version constraints

Exact version:
This accepts only version 5.1.2.

B. Understand the ~> operator

|Constraint |

| Meaning|
|---|---|
| = 5.1.2 |

| Exactly version 5.1.2|

|~> 5.0|

|Versions from 5.0 onward within major version 5|

|~> 5.1.0|

|Versions from 5.1.0 up to, but not including, 5.2.0|

|>= 5.0, < 6.0|

|Versions from 5.0 up to, but not including, 6.0|

Easy trick to remember:

~> 5.0 allows compatible 5.x releases.

~> 5.1.0 restricts updates to the 5.1.x patch series.
C. Pin a Git module using a tag
```bash
module "ec2_instance" {
  source = "git::https://github.com/YOUR_USERNAME/YOUR_REPO.git//modules/ec2_instance?ref=v1.2.0"
}
```
Replace the placeholders with your actual repository details.

git:: specifies a Git source.

//modules/ec2_instance selects the module directory.

?ref=v1.2.0 selects the Git tag or reference.

Git-sourced modules use a Git reference rather than the Registry's version argument.
D. Pin a Git module using a commit SHA
```bash
module "ec2_instance" {
  source = "git::https://github.com/YOUR_USERNAME/YOUR_REPO.git//modules/ec2_instance?ref=0123456789abcdef0123456789abcdef01234567"
}
```
The commit SHA is an illustrative placeholder. Replace it with a real commit SHA from your repository.

A commit SHA identifies a specific Git commit and provides a more precise source revision than a moving branch such as main.

Why does pinning matter?

Makes deployments more reproducible.

Reduces unexpected module upgrades.

Helps teams use consistent infrastructure code.

Makes changes easier to review and troubleshoot.

🛡️ 11. Add Input Validation

Input validation helps catch incorrect values before Terraform attempts to create resources.

Example for modules/ec2_instance/variables.tf:
Now only dev, stg, and prd are accepted.

Remember: Validation catches invalid configuration inputs early.

📄 12. .gitignore for Terraform Projects

Terraform downloads providers and modules into .terraform/. State files and variable files can also contain sensitive information.

Create a .gitignore file in your project root.
---------
✅ 17. Final Revision Checklist

Understood root modules and child modules.

Created a reusable EC2 module.

Defined module inputs using variables.

Exposed module outputs.

Called the child module from the root module.

Practiced for_each with multiple servers.

Explored the AWS VPC Registry module.

Understood Registry constraints and Git references.

Added input validation.

Created a Terraform .gitignore.

Learned which Terraform files should be committed.

Practiced Git commands for pushing to GitHub.

Reviewed the plan and cleaned up test infrastructure.



  

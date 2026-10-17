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

  

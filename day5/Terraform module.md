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

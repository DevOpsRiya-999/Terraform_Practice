🌱 TerraWeek Day 1 — Beginner's Study Guide
Task 1: Understand IaC and Terraform
1. What is Infrastructure as Code (IaC)?
Imagine creating an EC2 instance manually by opening the AWS Console, clicking buttons, selecting options, and configuring security groups.
* Problems IaC solves:
- Reduces repetitive manual work.
- Makes infrastructure easier to reproduce.
- Helps teams review changes using Git.
- Reduces configuration mistakes.
- Supports automation through CI/CD pipelines.
2. What is Terraform?
Terraform is an Infrastructure as Code tool developed by HashiCorp.
You describe the infrastructure you want, and Terraform determines the changes required to reach that desired configuration.
------------------------
Task 2: Install Terraform
Install Terraform using the official guide:[ Terraform installation guide](https://developer.hashicorp.com/terraform/install).

<img width="1017" height="170" alt="image" src="https://github.com/user-attachments/assets/e492b956-dd3e-4ea2-845a-6138fc30b2c0" />
-------------------------

Task 3: Six crucial Terraform terminologies
1. Provider
A plugin that allows Terraform to communicate with a platform.
Example: The AWS provider lets Terraform manage AWS resources.
2. Resource

An individual infrastructure object Terraform manages.
Example: An aws_instance resource represents an EC2 instance.
3. State

Terraform's record of the resources it manages.
Example: terraform.tfstate can record the ID of your EC2 instance.
>>Terraform State is like Terraform's memory book.
The state file is usually named terraform.tfstate.
main.tf |	terraform.tfstate
Contains your desired configuration|	Tracks the resources Terraform manages
Written by you	| Usually maintained by Terraform
Says what you want to create	| Records what Terraform knows about the resources
Written in HCL |	Stored as JSON data

4. Plan

A preview of the changes Terraform intends to make.
Example: terraform plan shows whether Terraform proposes to create, update, or destroy resources.

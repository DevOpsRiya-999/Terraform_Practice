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

--------------------------------------------------------

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
|---|---|
| Contains your desired configuration|	Tracks the resources Terraform manages|
| Written by you	| Usually maintained by Terraform |
| Says what you want to create	| Records what Terraform knows about the resources |
| Written in HCL |	Stored as JSON data |

4. Plan

A preview of the changes Terraform intends to make.
Example: terraform plan shows whether Terraform proposes to create, update, or destroy resources.
>> Terraform analyzes both the written configuration provided by the developer and the current state of the organization’s infrastructure.
   It then creates an execution plan describing how it will reach the desired state from the current state.
5.HCL — HashiCorp Configuration Language, the syntax you write Terraform in.
>> HashiCorp Configuration Language, used to write Terraform configuration.
Example: main.tf contains HCL blocks that describe resources.
<block> <parameters>{
<arrguments>}
6. Module

A reusable collection of Terraform configuration files.
Example: You can create an EC2 module and reuse it across different environments.
* Modules
- Modules are reusable containers for multiple resources that are commonly used together. For example, a module might contain virtual machines, databases, network configurations and security settings all in one package. Modules are stored as collections of configuration files.

- Terraform modules allow developers to create complex infrastructure without starting from scratch every time. Instead, they can use modules that already describe the infrastructure arrangements they need.
--------------------------------
Task 4: Create your first Terraform resource — no cloud cost

Run the core Terraform workflow and capture the output of each step:

cd example
terraform init      # download providers, initialize the working directory
<img width="918" height="582" alt="image" src="https://github.com/user-attachments/assets/ed2a27c5-b46b-4c24-a960-0176c9e1da32" />

terraform fmt       # format your code
>> basically it format the hcl file e.g. main.tf file 

terraform validate  # check for syntax errors

<img width="702" height="117" alt="image" src="https://github.com/user-attachments/assets/49a5dfa6-ef06-40c3-ab67-390a1192d071" />

terraform plan      # preview what will be created
<img width="847" height="810" alt="image" src="https://github.com/user-attachments/assets/93131c68-a339-45bb-8d69-77f98d808870" />

terraform apply     # create the resources (type: yes)

<img width="925" height="860" alt="image" src="https://github.com/user-attachments/assets/dbfc7145-772b-499f-a95f-ef649ef1c64e" />

cat greeting.txt    # see the file Terraform generated
<img width="923" height="231" alt="image" src="https://github.com/user-attachments/assets/15c55682-14e3-4f14-9f15-132836d45406" />

terraform destroy   # clean up (type: yes)

<img width="873" height="847" alt="image" src="https://github.com/user-attachments/assets/e5cb7c26-85d5-41b3-a941-6d5b34b7c7d8" />

-------------------------------------------
📁 Files Terraform Creates
 | File / folder |	Commit to Git? |
|---|---|
| .terraform/	| ❌ No |
| terraform.tfstate	| ❌ Never| 
| .terraform.lock.hcl| ✅ Yes |
| *.tf |	✅ Yes | 

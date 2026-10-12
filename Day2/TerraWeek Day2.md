# 🧩 TerraWeek Day 2 — HCL Deep Dive: Variables, Types & Expressions
------------------------
Date: Monday, 12th October 2026

Yesterday you ran your first apply. Today you'll learn the language behind it — HCL (HashiCorp Configuration Language) — so your configs become flexible, reusable, and readable. ✍️

---------------------

## Task 1: Master HCL Syntax
The anatomy of a block: block_type "label_one" "label_two" { argument = value }.
Block: a container for configuration.
<Block>
- resource 
- provider
- variable
- output
- data
- locals
- terraform
- module

• Arguments: Body configurations wrapped in curly braces { } that assign values to settings.
- Argument: a setting inside a block
- The difference between a block and an argument in Terraform is structural: a block is a container, whereas an argument is a configuration setting placed inside that container.
- To use a simple analogy, if a Terraform file is a house, blocks are the rooms (like the kitchen or bedroom), and arguments are the furniture and appliances placed inside those rooms (like    the refrigerator or bed).
------------------------------------------------
# Task 2: Variables, Types & Validation

Imagine you have a website running in three environments: development, staging, and production.
Without variables, you might need to edit the same values in several places. Variables let you provide values without rewriting your configuration.

For example:
```bash
variable "environment" {
  type    = string
  default = "dev"
}
```

Here:
- `variable` defines an input.
- `"environment"` is its name.
- `type = string` means it accepts text.
- `default = "dev"` means Terraform uses dev when you don't provide another value.
  ## Terraform data types
|Type	|Simple meaning	|Example |
|---|---|---|
|string |	Text |	"dev"|
| number	|Number	 |8080 |
| bool	|True or false	| true|
|list(string)	|Ordered list of text |	["dev", "prod"] |
|map(string)	| Named text values	| { team = "DevOps" } |
|set(string) |	Unique text values |	["dev", "prod"] |
|object({...}) |	An object with named fields and specified types	|{ name = "web", port = 8080 } |
tuple([...])	An ordered collection with specified types at each position	["web", 8080, true]

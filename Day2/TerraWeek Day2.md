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

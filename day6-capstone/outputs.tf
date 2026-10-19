output "environment" {
  description = "Active Terraform workspace"
  value       = terraform.workspace
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "web_instance_id" {
  description = "ID of the web server"
  value       = module.web_server.instance_id
}

output "website_url" {
  description = "URL of the web server"
  value       = "http://${module.web_server.public_ip}"
}

output "selected_instance_type" {
  description = "EC2 instance size selected for this environment"
  value       = local.environment == "prod" ? "t3.micro" : var.instance_type
}
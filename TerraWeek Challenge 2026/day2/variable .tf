variable "project_name" {
  type    = string
  default = "terraweek"
}

variable "port" {
  type    = number
  default = 8080
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

variable "environments" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}

variable "tags" {
  type = map(string)

  default = {
    team        = "DevOps"
    environment = "dev"
  }
}

variable "unique_names" {
  type    = set(string)
  default = ["web", "api", "web"]
}

variable "server" {
  type = object({
    name = string
    port = number
  })

  default = {
    name = "web"
    port = 8080
  }
}

variable "settings" {
  type    = tuple([string, number, bool])
  default = ["web", 8080, true]
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition = contains(
      ["dev", "staging", "prod"],
      var.environment
    )

    error_message = "Use dev, staging, or prod."
  }
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}


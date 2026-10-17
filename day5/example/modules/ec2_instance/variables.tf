variable "name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
  
#validation block to ensure environment is one of the allowed values
    validation {            
    condition = contains(
      ["dev", "stg", "prd"],
      var.environment
    )

    error_message = "Environment must be dev, stg, or prd."
  }
}


variable "ami" {
  description = "AMI ID for the instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet where EC2 will be launched"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Security groups attached to EC2"
  type        = list(string)
}
variable "aws_region" {
  description = "AWS region for the capstone"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name used for the project"
  type        = string
  default     = "terraweek-day6"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}
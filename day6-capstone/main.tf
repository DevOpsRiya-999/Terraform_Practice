
locals {
  environment = terraform.workspace

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

# Retrieve the latest official Ubuntu 24.04 AMI through SSM.
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Create the VPC using the official Terraform Registry module.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${var.project_name}-${local.environment}"
  cidr = "10.20.0.0/16"

  azs             = ["${var.aws_region}a"]
  public_subnets  = ["10.20.1.0/24"]
  private_subnets = []

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = local.common_tags

  # Enable VPC traffic logging
  # enable_flow_log = true

  # flow_log_destination_type = "cloud-watch-logs"
  #flow_log_traffic_type     = "ALL"

  #create_flow_log_cloudwatch_iam_role  = true
  #create_flow_log_cloudwatch_log_group = true

  #flow_log_cloudwatch_log_group_retention_in_days = 7
}

# Create the web server using your custom module.
module "web_server" {
  source = "./modules/web-server"

  project_name = var.project_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.public_subnets[0]

  # SSM returns the AMI ID as a string value.
  ami_id = data.aws_ssm_parameter.ubuntu_ami.value

  instance_type = (
    local.environment == "prod"
    ? "t3.micro"
    : var.instance_type
  )

  tags = local.common_tags
}

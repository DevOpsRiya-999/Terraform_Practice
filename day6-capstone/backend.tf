terraform {
  backend "s3" {
    bucket       = "myorg-terraform-state-unique-12345"
    key          = "terraweek-day6/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
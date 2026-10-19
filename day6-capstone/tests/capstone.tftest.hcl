run "default_environment_uses_small_instance" {
  command = plan

  assert {
    condition     = output.selected_instance_type == "t3.micro"
    error_message = "The default environment should use t3.micro."
  }

  assert {
    condition     = output.environment == "default"
    error_message = "This test expects the default workspace."
  }
}



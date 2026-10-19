resource "aws_security_group" "web" {
  name        = "${var.project_name}-${var.environment}-web"
  description = "Allow public HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "Allow outbound HTTP for package downloads"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    description = "Allow outbound HTTPS for secure package downloads"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags

}


resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  # Require IMDSv2 session tokens.
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  # Encrypt the EC2 root volume.
  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 8
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e
    apt-get update
    apt-get install -y nginx
    systemctl enable --now nginx
    echo '<h1>TerraWeek Day 6 Capstone</h1>' > /var/www/html/index.html
  EOF

  user_data_replace_on_change = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-web"
  })
}
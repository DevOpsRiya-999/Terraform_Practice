
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "website_url" {
  description = "URL of the Nginx website"
  value       = "http://${aws_instance.web.public_ip}"
}

output "availability_zone" {
  description = "Availability zone selected for the subnet"
  value       = aws_subnet.public.availability_zone
}

output "ami_id" {
  description = "Amazon Linux AMI selected by the data source"
  value       = data.aws_ami.amazon_linux.id
}

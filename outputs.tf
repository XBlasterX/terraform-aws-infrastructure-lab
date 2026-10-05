output "vpc_id" {
  value = module.network.vpc_id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "website_url" {
  value = "http://${aws_instance.web.public_ip}"
}
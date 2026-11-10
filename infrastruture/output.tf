output "public_ip" {
  value = aws_instance.ec2.public_ip
}

output "public_dns" {
  value = aws_instance.ec2.public_dns
}

output "ssh_command" {
  value = "ssh -i viren-ec2-key ubuntu@${aws_instance.ec2.public_ip}"
}

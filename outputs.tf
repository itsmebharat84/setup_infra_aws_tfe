output "instance_public_ip" {
  value = aws_instance.dev_box.public_ip
}

output "instance_public_dns" {
  value = aws_instance.dev_box.public_dns
}

output "ssh_private_key_path" {
  value       = var.use_existing_key_name ? "Using existing key: ${var.existing_key_name}" : local_file.private_key_pem[0].filename
  description = "Path to the generated private key (if we created one)."
}

output "ssh_example_command" {
  value = var.use_existing_key_name ?
    format("ssh -i ~/.ssh/%s.pem ec2-user@%s", var.existing_key_name, aws_instance.dev_box.public_dns) :
    format("ssh -i %s ec2-user@%s", local_file.private_key_pem[0].filename, aws_instance.dev_box.public_dns)
}


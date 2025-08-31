/*
# Look up latest Amazon Linux 2023 x86_64 HVM AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Default VPC & a public subnet (first one we find)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Option A: generate a fresh SSH key pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  count      = var.use_existing_key_name ? 0 : 1
  key_name   = "${var.project}-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "private_key_pem" {
  count    = var.use_existing_key_name ? 0 : 1
  content  = tls_private_key.ssh.private_key_pem
  filename = "${path.module}/${var.project}.pem"
  file_permission = "0600"
}

# Select key name based on mode
locals {
  key_name = var.use_existing_key_name ? var.existing_key_name : aws_key_pair.generated[0].key_name
}

# Cloud-init user_data to install Python, pip, Docker, Git
# Amazon Linux 2023 uses dnf
locals {
  user_data = <<-EOF
    #!/usr/bin/env bash
    set -euxo pipefail

    # Update
    dnf -y update

    # Install basics: Python3, pip, git, docker
    dnf -y install python3 python3-pip git docker

    # Enable & start docker
    systemctl enable docker
    systemctl start docker

    # Allow ec2-user to use docker without sudo
    usermod -aG docker ec2-user || true

    # Verify versions on first boot (optional logs)
    python3 --version || true
    pip3 --version || true
    git --version || true
    docker --version || true

    # OpenSSH server is installed & enabled by default on AL2023; ensure it's running
    systemctl enable sshd
    systemctl restart sshd
  EOF
}

# EC2 Instance
resource "aws_instance" "dev_box" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnets.default_public.ids, 0)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = local.key_name
  user_data                   = local.user_data

  # Recommended metadata settings
  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name        = "devops-bootstrap-ec2"
    Project     = var.project
    Owner       = var.owner
    CostCenter  = var.cost_center
    ManagedBy   = "terraform"
    Environment = "dev"
  }

  # Root volume with encryption on
  root_block_device {
    encrypted   = true
    volume_size = 20
    volume_type = "gp3"
  }

  lifecycle {
    ignore_changes = [user_data] # prevents reboots if script changes later
  }
}
*/

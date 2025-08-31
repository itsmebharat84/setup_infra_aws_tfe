/*
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and app access"
  vpc_id      = data.aws_vpc.default.id

 

    ingress {
    description = "SSH IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    description      = "SSH IPv6"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }


  # Port 4000 (open to the world)
  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



    egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "ec2-ssh-anywhere"
    Project     = var.project
    Owner       = var.owner
    CostCenter  = var.cost_center
    ManagedBy   = "terraform"
    Environment = "dev"
  }
}
*/

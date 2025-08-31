variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "use_existing_key_name" {
  description = "If true, use existing key pair specified by existing_key_name; otherwise create one"
  type        = bool
  default     = false
}

variable "existing_key_name" {
  description = "Existing AWS key pair name (used when use_existing_key_name = true)"
  type        = string
  default     = ""
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH (0.0.0.0/0 allows from anywhere)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "project" {
  description = "Tag: Project"
  type        = string
  default     = "devops-ec2-bootstrap"
}

variable "owner" {
  description = "Tag: Owner"
  type        = string
  default     = "platform-team"
}

variable "cost_center" {
  description = "Tag: Cost Center"
  type        = string
  default     = "cc-0001"
}

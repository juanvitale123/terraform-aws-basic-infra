variable "aws_region" {
  description = "AWS region where the infrastructure is deployed"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for the web server"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair used for SSH access"
  type        = string
  default     = "terraform-key"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to reach the instance over SSH (use your own public IP, e.g. 203.0.113.10/32)"
  type        = string

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0)) && var.allowed_ssh_cidr != "0.0.0.0/0"
    error_message = "allowed_ssh_cidr must be a valid CIDR and must not open SSH to the whole internet (0.0.0.0/0)."
  }
}

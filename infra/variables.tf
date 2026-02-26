variable "aws_region" {
  type        = string
  default     = "eu-north-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "devtest_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for Dev/Test subnet"
}

variable "production_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR block for Production subnet"
}

variable "control_plane_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Instance type for control plane nodes"
}

variable "worker_instance_type" {
  type        = string
  default     = "t3.small"
  description = "Instance type for worker nodes"
}

variable "ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR allowed to SSH into instances"
}

variable "key_name" {
  type        = string
  default     = null
  description = "Optional EC2 key pair name for SSH access"
}

variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "be_instance_type" {
  type    = string
  default = "t3.micro"

  validation {
    condition     = can(regex("^(t2.micro|t3.micro)$", var.be_instance_type))
    error_message = "Instance type must be free tier - choose from t2.micro or t3.micro"
  }
}

variable "fe_instance_type" {
  type    = string
  default = "t3.micro"

  validation {
    condition     = can(regex("^(t2.micro|t3.micro)$", var.fe_instance_type))
    error_message = "Instance type must be free tier - choose from t2.micro or t3.micro"
  }
}

variable "vpc_cidr_range" {
  description = "CIDR block for vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_main" {
  description = "Main availability zone"
  type        = string
  default     = "eu-north-1a"
}

variable "az_secondary" {
  description = "Secondary availability zone"
  type        = string
  default     = "eu-north-1b"
}

variable "instance_volume_size" {
  description = "EBS volume size in GBs"
  type        = number
  default     = 8
}

variable "instance_volume_type" {
  description = "EBS volume type"
  type        = string
  default     = "gp2"
}

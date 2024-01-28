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
  default     = 30

  validation {
    condition     = var.instance_volume_size >= 30
    error_message = "ECS optimised AMI requires volumes size >=30"
  }
}

variable "instance_volume_type" {
  description = "EBS volume type"
  type        = string
  default     = "gp2"
}

variable "fe_image_tag" {
  description = "Docker image tag to be used for FE deployment"
  type        = string
  default     = "latest"
}

variable "be_image_tag" {
  description = "Docker image tag to be used for BE deployment"
  type        = string
  default     = "latest"
}

variable "ecs_optimised_ami" {
  description = "An ECS optimised AMI used by the Autoscaling group"
  type        = string
  default     = "ami-0bf78b8d71f876aa6"

  validation {
    condition     = length(var.ecs_optimised_ami) > 4 && substr(var.ecs_optimised_ami, 0, 4) == "ami-"
    error_message = "The ecs_optimised_ami value must be a valid AMI id, starting with \"ami-\"."
  }
}

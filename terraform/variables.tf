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

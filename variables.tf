variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
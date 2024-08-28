variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
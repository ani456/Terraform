variable "create_rds" {
  description = "Whether to create an RDS instance"
  type        = bool
  default     = false
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "root"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "thisisrootpassword"
}

variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance will be created"
  type        = string
  default     = "aws_vpc.poneglyph1-vpc.id"
}

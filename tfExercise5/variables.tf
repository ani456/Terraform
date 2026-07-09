##root/ Global variables declaration

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

variable "create_rds" {
  type    = bool
  default = false
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}



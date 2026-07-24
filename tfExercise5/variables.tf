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
  sensitive   = true
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t3.micro"
}
variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "jumpserver"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "linux-key"
}

variable "jumpserver_sg_id" { ##preferred to user sg id instead of name
  description = "Security group ID for the jumpserver"
  type        = string
  default     = ""
}

variable "jumpserver_subnet_id" {
  description = "Subnet ID for the jumpserver"
  type        = string
  default     = ""
}

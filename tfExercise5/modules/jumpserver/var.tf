variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "jumpserver"
}

variable "instance_type" {
  description = "Type of the Ec2 instance"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  type        = string
  default     = "my-key-pair"
}

variable "jumpserver_sg_id" {
  description = "Security group ID for the jumpserver"
  type        = string
  default     = ""
}
variable "jumpserver_subnet_id" {
  description = "Subnet ID for the jumpserver"
  type        = string
  default     = ""
}

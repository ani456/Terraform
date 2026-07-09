

variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance will be created"
  type        = string
  default     = "aws_vpc.poneglyph1-vpc.id"
}

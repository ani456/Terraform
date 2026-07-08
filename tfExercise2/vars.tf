variable "region" {
  default = "us-east-1"
}

variable "zone" {
  default = "us-east-1a"
}
variable "webuser" {
  default = "ubuntu"
}


variable "ami_id" {
  type = map(any)
  default = {
    "us-east-1" = "ami-0ecb62995f68bb549"
    "us-east-2" = "ami-0f5fcdfbd140e4ab7"
  }
}


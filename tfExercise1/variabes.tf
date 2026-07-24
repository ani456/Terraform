variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
  default     = "poneglyph-bucket"
}
variable "tags" {
  type    = map(string)
  default = {}
}

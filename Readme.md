##Variables:

    variables.tf
              Defines what variables exist, their types, descriptions, and optional defaults.
                          variable "instance_type" {
                               description = "EC2 instance type"
                               type        = string
                               default     = "t3.micro"

}
terraform.tfvars
Provides values for those variables.
instance_type = "t3.small"
environment = "dev"

##Workspace:
command - terraform workspace new <workspace name>

#################### for different tfvars file for each workspace
terraform workspace select prod
terraform apply -var-file=prod.tfvars
###################
terraform workspace select dev
terraform apply -var-file=dev.tfvars

terraform.workspace ## returns the workspace you are currently working in

#############################################################################
variable "instance" {
type = map(string)

default = {
dev = "t2.micro"
stage = "t2.medium"
}
}
instance_type = lookup(var.instance, terraform.workspace, "t2.micro")
#############################################################################

File Purpose Syntax
variables.tf Declare variables variable "name" { ... }
terraform.tfvars Set variable valuesname = "value"

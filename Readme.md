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

####### Referencing values from another module ✅ Output required ###########

If you just added a new module block (like your rds case), terraform init will only add/update entries for any new providers that module requires. Existing provider entries stay untouched.

####### Getting the same endpoint for every rds instance ############

An RDS endpoint looks like:
<db-instance-identifier>.<random-suffix>.<region>.rds.amazonaws.com

The <random-suffix> part (e.g. abcdefghijkl) is a unique identifier generated internally by RDS for a specific combination of AWS Region and AWS account, and it doesn't change for that Region/account combination — meaning all your DB instances in that Region share the same fixed identifier.

- Your app configs / connection strings don't need to change between recreations.
- It only changes if you change the DB instance identifier or deploy to a different region.

#########

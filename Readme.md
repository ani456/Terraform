Latest changes in this repositoy are going in tfExercise5

Consisting of the Multitier Aws architecture setup with Terraform

## Variables:

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

## Workspace:

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

###### Referencing values from another module ✅ Output required

-If you just added a new module block (like your rds case), terraform init will only add/update entries for any new providers that module requires. Existing provider entries stay untouched.

#### Getting the same endpoint for every rds instance

-An RDS endpoint looks like:
<db-instance-identifier>.<random-suffix>.<region>.rds.amazonaws.com

-The <random-suffix> part (e.g. abcdefghijkl) is a unique identifier generated internally by RDS for a specific combination of AWS Region and AWS account, and it doesn't change for that Region/account combination — meaning all your DB instances in that Region share the same fixed identifier.

- Your app configs / connection strings don't need to change between recreations.
- It only changes if you change the DB instance identifier or deploy to a different region.

#########Terraform plan

# dev(workspace)

terraform plan -var-file="terraform.tfstate.d/dev/terraform.tfvars" -out=plan1.out

- -var-file is requried as the terraform.tfvars is not located at the root directory
  -runs terraform plan command and stores the plan in plan1.out file which can be used to only provision the infrastructure specified in the plan1.out file.

-Thus continue to add new configuration while having a snapshot of the old configuration

## Benefits of terraform plan to file

-What you reviewed is exactly what gets applied
-No risk of infrastructure changing between plan and apply
-Without the file, running plan then apply separately could produce different results if someone else made changes in between.

- After plan with -var-file , no need to provide in apply again.

#################################################################

Whenever you're wiring two resources together and unsure whether to use .id, .name, or .arn, check the required argument description in the Terraform provider docs for the field you're filling in — it'll literally say "Name of the autoscaling group" or "ARN of the target group."

###Egress-only internet Gateway #############################

- NAT Gateways only support IPv4. There's no such thing as an "IPv6 NAT Gateway" in AWS
- So we need an egress only internet gateway for ipv6
- allows outbound communication over IPv6 from instances in your VPC to the internet, and prevents the internet from initiating an IPv6 connection with your instances.

### if want to rename terraform.tfstate.d

- Option 1 — Just leave it as terraform.tfstate.d. This is standard convention; every Terraform project using workspaces has this exact folder name. There's no real downside to keeping it as-is.
- Option 2 — If you truly want custom-named per-environment state files, don't use Terraform workspaces at all. Instead, use separate state files via -state flag or backend config per environment, with your own folder structure:

environments/
dev/
terraform.tfstate
prod/
terraform.tfstate

## Outpub block is required when you want to pass the value of one moudles to another.

#### Remote Backend

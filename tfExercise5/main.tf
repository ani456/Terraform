## contains the modules that need to be called for the project to be created. 
##The modules are called in the main.tf file. The modules are located in the modules folder. 

## main.tf also used to pass values to the modules.
module "rds-alb-sg-vpc" {
  source = "./modules"

  create_rds  = var.create_rds
  db_username = var.db_username
  db_password = var.db_password
}

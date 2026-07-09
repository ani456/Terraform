## contains the modules that need to be called for the project to be created. 
##The modules are called in the main.tf file. The modules are located in the modules folder. 
module "dev-vpc" {
  source = "./modules"
}

module "rds" {
  source = "./modules"
}

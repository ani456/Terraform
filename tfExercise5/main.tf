
module "dev-vpc" {
  source = "./modules"
}

module "rds" {
  source = "./modules"
}

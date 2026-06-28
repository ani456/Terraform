
module "dev-vpc" {
  source = "./modules"
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.dev-vpc.vpc_id
}

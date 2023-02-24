resource "random_id" "random_id_prefix" {
  byte_length = 2
}

module "ec2" {
  source      = "./modules/ec2"
  region      = var.AWS_REGION
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  #public_subnets_cidr  = var.public_subnets_cidr
  #private_subnets_cidr = var.private_subnets_cidr
  #availability_zone   = local.production_availability_zones

}
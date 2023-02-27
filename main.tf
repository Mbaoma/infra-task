resource "random_id" "random_id_prefix" {
  byte_length = 2
}

module "ec2" {
  source              = "./modules/ec2"
  region              = var.AWS_REGION
  vpc_id              = module.networking.vpc_id
  sg_id               = module.networking.sg_id
  private_subnet_cidr = module.networking.private_subnet_id
  public_subnet_cidr  = module.networking.public_subnet_id
  subnet_id           = module.networking.subnet_id
  subnet_id2           = module.networking.subnet_id2
}

module "networking" {
  source      = "./modules/vpc"
  instance_id = module.ec2.instance_id
}
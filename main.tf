resource "random_id" "random_id_prefix" {
  byte_length = 2
}

module "ec2" {
  source                 = "./modules/ec2"
  region                 = var.AWS_REGION
  infra_task_vpc_id      = module.networking.infra_task_vpc_id
  infra_task_sg_id       = module.networking.infra_task_sg_id
  infra_task_subnet_id   = [module.networking.infra_task_public_subnet_1_id, module.networking.infra_task_public_subnet_2_id]
  infra_task_subnet_id_1 = module.networking.infra_task_public_subnet_1_id
  # environment = var.environment

}

module "networking" {
  source                 = "./modules/vpc"
  infra_task_instance_id = module.ec2.infra_task_instance_id
}
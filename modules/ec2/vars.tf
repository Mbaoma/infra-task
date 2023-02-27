# variable "environment" {
#   description = "Deployment Environment"
#   default     = "InfraTask"
# }

variable "region" {
  description = "Region"
  default     = "us-east-2"
}

# variable "availability_zone1" {
#   type        = string
#   description = "AZ in which all the resources will be deployed"
#   default     = "us-east-1f"
# }

# variable "availability_zone2" {
#   type        = string
#   description = "AZ in which all the resources will be deployed"
#   default     = "us-east-1e"
# }

variable "algorithm" {
  type        = string
  default     = "RSA"
  description = "Algorithm"
}

variable "key_name" {
  type        = string
  default     = "InfraTask"
  description = "InfraTask"
}

variable "filename" {
  type        = string
  default     = "InfraTask.pem"
  description = "private key"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "ami"
}

variable "infra_task_sg_id" {}

variable "infra_task_subnet_id" {}

variable "infra_task_subnet_id_1" {}
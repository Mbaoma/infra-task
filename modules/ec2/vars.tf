variable "environment" {
  description = "Deployment Environment"
  default     = "InfraTask"
}

variable "region" {
  description = "Region"
  default     = "us-west-1"
}

variable "availability_zone1" {
  type        = string
  description = "AZ in which all the resources will be deployed"
  default     = "us-west-1b"
}

variable "availability_zone2" {
  type        = string
  description = "AZ in which all the resources will be deployed"
  default     = "us-west-1c"
}

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

variable "ami" {
  type        = string
  default     = "ami-00569e54da628d17c"
  description = "ami"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "ami"
}

variable "sg_id" {}

variable "public_subnet_cidr" {}

variable "private_subnet_cidr" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "subnet_id2" {}
variable "environment" {
  description = "Deployment Environment"
  default     = "InfraTask"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
  default     = ["172.31.0.0/20"]
}


variable "private_subnet_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["172.31.0.0/20"]
}

variable "region" {
  description = "Region"
  default     = "us-west-2"
}

variable "availability_zone1" {
  type        = string
  description = "AZ in which all the resources will be deployed"
  default     = "us-west-2a"
}

variable "availability_zone2" {
  type        = string
  description = "AZ in which all the resources will be deployed"
  default     = "us-west-2b"
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

variable "destination_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "destination_cidr_block"
}

variable "ami" {
  type        = string
  default     = "ami-0b5eea76982371e91"
  description = "ami"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "ami"
}
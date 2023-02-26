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
  default     = ["10.0.1.0/24"]
}


variable "private_subnet_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["10.0.4.0/24"]
}

variable "region" {
  description = "Region"
  default     = "us-east-1"
}

variable "availability_zone1" {
  type        = string
  description = "AZ in which all the resources will be deployed"
  default     = "us-east-1f"
}

variable "availability_zone2" {
  type        = string
  description = "AZ in which all the resources will be deployed"
  default     = "us-east-1e"
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

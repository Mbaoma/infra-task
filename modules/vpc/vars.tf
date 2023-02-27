variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

# variable "subnet_id" {
#   type    = list(any)
#   default = ["10.0.3.0/24", "10.0.4.0/24"]
# }

variable "public_subnet_cidr" {
  description = "CIDR block for Public Subnet"
  default     = "10.0.2.0/24"
}


variable "private_subnet_cidr" {
  description = "CIDR block for Private Subnet"
  default     = "10.0.1.0/24"
}

variable "instance_id" {
  type = string
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
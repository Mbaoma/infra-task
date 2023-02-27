variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(any)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable infra_task_instance_id{
  type        = string
}
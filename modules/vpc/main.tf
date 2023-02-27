# Internet VPC
resource "aws_vpc" "infra_task_vpc" {
	cidr_block           =  var.vpc_cidr # "10.0.0.0/16"
	instance_tenancy     = "default"
	enable_dns_support   = "true"
	enable_dns_hostnames = "true"
	enable_classiclink   = "false"
	tags = {
		Name = "infra-task-vpc"
	}
}

# Subnets
resource "aws_subnet" "infra_task_public_subnet_1" {
	vpc_id                  = aws_vpc.infra_task_vpc.id
	cidr_block              = var.public_subnets_cidr[0] # "10.0.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone 	 = "us-east-2a"

	tags = {
		Name = "infra-task-public-subnet-1"
	}
}

resource "aws_subnet" "infra_task_public_subnet_2" {
	vpc_id                  = aws_vpc.infra_task_vpc.id
	cidr_block              = var.public_subnets_cidr[1] # "10.0.2.0/24"
	map_public_ip_on_launch = "true"
	availability_zone 	 = "us-east-2b"

	tags = {
		Name = "infra-task-public-subnet-2"
	}
}

resource "aws_subnet" "infra_task_private_subnet_1" {
	vpc_id                  = aws_vpc.infra_task_vpc.id
	cidr_block              = var.private_subnets_cidr[0] # "10.0.3.0/24"
	map_public_ip_on_launch = "true"
	availability_zone 	 = "us-east-2a"

	tags = {
		Name = "infra-task-private-subnet-1"
	}
}

resource "aws_subnet" "infra_task_private_subnet_2" {
	vpc_id                  = aws_vpc.infra_task_vpc.id
	cidr_block              = var.private_subnets_cidr[1] # "10.0.4.0/24"
	map_public_ip_on_launch = "false"
	availability_zone 	 = "us-east-2b"

	tags = {
		Name = "infra-task-private-subnet-2"
	}
}

# Internet GW
resource "aws_internet_gateway" "infra_task_gw" {
	vpc_id = aws_vpc.infra_task_vpc.id

	tags = {
		Name = "infra-task-gw"
	}
}

# route tables
resource "aws_route_table" "infra_task_public" {
	vpc_id = aws_vpc.infra_task_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.infra_task_gw.id
	}

	tags = {
		Name = "infra-task-public"
	}
}

# route associations public
resource "aws_route_table_association" "infra_task_public_1_a" {
	subnet_id      = aws_subnet.infra_task_public_subnet_1.id
	route_table_id = aws_route_table.infra_task_public.id
}

resource "aws_route_table_association" "infra_task_public_2_a" {
	subnet_id      = aws_subnet.infra_task_public_subnet_2.id
	route_table_id = aws_route_table.infra_task_public.id
}



resource "aws_security_group" "infra_task_sg" {
	vpc_id      = aws_vpc.infra_task_vpc.id
	name        = "infra_task_sg"
	description = "security group that allows ssh and all egress traffic"
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		description     = "SSH in public subnet"
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	  ingress {
    description     = "HTTPS in public subnet"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description     = "HTTS in public subnet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "infra_task_sg"
  }

}

#Output
output "infra_task_vpc_id" {
	value = aws_vpc.infra_task_vpc.id
}

output "infra_task_sg_id" {
	value = aws_security_group.infra_task_sg.id
}

output "infra_task_public_subnet_1_id" {
	value = aws_subnet.infra_task_public_subnet_1.id
}

output "infra_task_public_subnet_2_id" {
	value = aws_subnet.infra_task_public_subnet_2.id
}

output "infra_task_private_subnet_1_id" {
	value = aws_subnet.infra_task_private_subnet_1.id
}

output "infra_task_private_subnet_2_id" {
	value = aws_subnet.infra_task_private_subnet_2.id
}
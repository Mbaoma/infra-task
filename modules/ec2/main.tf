
resource "tls_private_key" "infra_key" {
  algorithm = var.algorithm
}

resource "aws_key_pair" "infra-task-key" {
  key_name   = var.key_name
  public_key = tls_private_key.infra_key.public_key_openssh
}

resource "local_file" "private_key" {
  depends_on = [
    tls_private_key.infra_key,
  ]
  content  = tls_private_key.infra_key.private_key_pem
  filename = var.filename
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = var.availability_zone1

  tags = {
    Name = "Default subnet"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = var.availability_zone2

  tags = {
    Name = "Default subnet2"
  }
}

# Default Security Group of VPC
resource "aws_security_group" "InfraTask_sg" {
  name        = "${var.environment}-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = aws_default_vpc.default.id
  depends_on = [
    aws_default_vpc.default
  ]

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = aws_default_vpc.default.cidr_block
  }

  ingress {
    description = "HTTPS in public subnet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS in public subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = "true"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb" "my-lb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.InfraTask_sg.id]
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id,]
  #[aws_default_subnet.default_az1.id, aws_subnet.private_subnet.id] #[for subnet in aws_default_subnet.default_az1 : subnet.id] 

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}


# EC2 instance
resource "aws_instance" "instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_default_subnet.default_az1.id
  #count                  = length(var.public_subnets_cidr)
  #subnet_id              = element(aws_default_subnet.default_az1.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.InfraTask_sg.id]
  key_name               = var.key_name
  user_data              = "${file("./userdata/script.sh")}"

  tags = {
    Name = "instance1"
  }
}

resource "aws_cloudwatch_metric_alarm" "monitorTaskEC2" {
  alarm_name                = "terraform-test-monitorTaskEC25"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    LoadBalancer = aws_lb.my-lb.arn_suffix
  }
}
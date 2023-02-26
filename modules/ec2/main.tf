
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

#resource "aws_default_vpc" "default" {
 # tags = {
  #  Name = "Default VPC"
  #}
#}

data "aws_vpc" "default" {
  default = true
  cidr_block = "10.0.0.0/16"
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
  vpc_id      = "vpc-0b73fe3e7482cfb21"  #aws_default_vpc.default.id
  depends_on = [data.aws_vpc.default]  #aws_default_vpc.default
  

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.InfraTask_sg.id]
  }

  ingress {
    description     = "HTTPS in public subnet"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.InfraTask_sg.id]
  }

  ingress {
    description     = "HTTPS in public subnet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.InfraTask_sg.id]
  }

  egress {
    from_port   = 0
    description = "Egress"
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
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, ]
  #[aws_default_subnet.default_az1.id, aws_subnet.private_subnet.id] #[for subnet in aws_default_subnet.default_az1 : subnet.id] 

  enable_deletion_protection = true
  drop_invalid_header_fields = true

  access_logs {
    bucket  = "testingci90pipeline5682wel98l"
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

#WAF
data "aws_wafregional_web_acl" "fwaf_protection" {
  name = "tfWAFRegionalWebACL"
}

resource "aws_wafregional_web_acl_association" "fwaf_protection" {
  resource_arn = aws_lb.my-lb.arn
  web_acl_id   = data.aws_wafregional_web_acl.fwaf_protection.id
}

resource "aws_network_interface" "ni" {
  subnet_id       = aws_default_subnet.default_az1.id
  private_ips     = aws_instance.instance.private_ip
  security_groups = [aws_security_group.InfraTask_sg.id]

  attachment {
    instance     = aws_instance.instance.id
    device_index = 1
  }
}

# EC2 instance
resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_default_subnet.default_az1.id
  #count                  = length(var.public_subnets_cidr)
  #subnet_id              = element(aws_default_subnet.default_az1.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.InfraTask_sg.id]
  key_name               = var.key_name
  #user_data              = "${file("./userdata/script.sh")}"
  ebs_optimized        = true
  monitoring           = true
  iam_instance_profile = "user"

  root_block_device {
    encrypted     = true
 }

  #network_interface {
  # network_interface_id = aws_network_interface.ni.id
  #device_index         = 0
  #}

  credit_specification {
    cpu_credits = "unlimited"
  }

  #rwaf_protectiont_block_device {
  # encrypted     = true
  #}

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
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
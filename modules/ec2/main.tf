
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

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

resource "aws_lb" "infra_task_lb" {
  name               = "infra-task-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.infra_task_sg_id]
  subnets            = var.infra_task_subnet_id

  # enable_deletion_protection = true
  drop_invalid_header_fields = true
}



# EC2 instance
resource "aws_instance" "infra_task_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.infra_task_subnet_id_1
  vpc_security_group_ids = [var.infra_task_sg_id]
  key_name               = var.key_name
  user_data              = "${file("./userdata/script.sh")}"
  availability_zone = "us-east-2a"
  tags = {
    Name = "infra-task-instance"
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
    LoadBalancer = aws_lb.infra_task_lb.arn_suffix
  }
}

#Output
output "infra_task_instance_ip_address" {
  value = aws_instance.infra_task_instance.public_ip
}

output "infra_task_instance_id" {
  value = aws_instance.infra_task_instance.id
}

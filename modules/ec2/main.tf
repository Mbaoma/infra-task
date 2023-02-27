
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

# EC2 instance
resource "aws_instance" "infra_task_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.infra_task_subnet_id_1
  vpc_security_group_ids = [var.infra_task_sg_id]
  key_name               = var.key_name
  user_data              = file("./userdata/script.sh")
  availability_zone      = "us-east-2a"
  tags = {
    Name = "infra-task-instance"
  }
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

resource "aws_lb_target_group" "infra_task_target_group" {
  name        = "infra-task-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.infra_task_vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "infra_task_listener" {
  load_balancer_arn = aws_lb.infra_task_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.infra_task_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "infra_task_target_group_attachment" {
  target_group_arn = aws_lb_target_group.infra_task_target_group.arn
  target_id        = aws_instance.infra_task_instance.id
  port             = 80
}

resource "aws_cloudwatch_metric_alarm" "infra_task_metric_alarm" {
  alarm_name                = "infra-task-metric-alarm"
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

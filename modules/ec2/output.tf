output "vpc_id" {
  value = aws_default_vpc.default.id
}

output "public_subnets_id" {
  value = ["${aws_default_subnet.default_az1.*.id}"]
}

output "private_subnets_id" {
  value = ["${aws_default_subnet.default_az2.*.id}"]
}

#output "default_sg_id" {
 # value = aws_security_group.InfraTask-sg.id
#}

#output "public_route_table" {
 # value = aws_route_table.public.id
#}

output ip_address {
  value = aws_instance.instance.public_ip
}
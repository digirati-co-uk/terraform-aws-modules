output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_public_1_id" {
  value = "${aws_subnet.public_1.id}"
}

output "subnet_public_2_id" {
  value = "${aws_subnet.public_2.id}"
}

output "subnet_private_1_id" {
  value = "${aws_subnet.private_1.id}"
}

output "subnet_private_2_id" {
  value = "${aws_subnet.private_2.id}"
}

output "route_table_public_1_id" {
  value = "${aws_route_table.public_1.id}"
}

output "route_table_public_2_id" {
  value = "${aws_route_table.public_2.id}"
}

output "route_table_private_1_id" {
  value = "${aws_route_table.private_1.id}"
}

output "route_table_private_2_id" {
  value = "${aws_route_table.private_2.id}"
}

output "subnet_public_1_az" {
  value = "${var.subnet_public_1_az}"
}

output "subnet_public_2_az" {
  value = "${var.subnet_public_2_az}"
}

output "subnet_private_1_az" {
  value = "${var.subnet_private_1_az}"
}

output "subnet_private_2_az" {
  value = "${var.subnet_private_2_az}"
}

output "nat_public_ip" {
  value = "${aws_nat_gateway.gw.public_ip}"
}

output "bastion_security_group" {
  value = "${aws_security_group.bastion.id}"
}

output "bastion_ip" {
  value = "${aws_eip.bastion.public_ip}"
}

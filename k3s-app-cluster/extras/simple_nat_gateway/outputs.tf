output "nat_gateway_ip" {
  value = aws_eip.nat_gateway.public_ip
}

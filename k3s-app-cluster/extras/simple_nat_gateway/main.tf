resource "aws_eip" "this" {
  vpc = true
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.nat_gateway.id
  tags = {
    "Name"       = "k3s-private-cluster"
    "Managed By" = "Terraform"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "this" {
  for_each       = toset(var.subnet_ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}

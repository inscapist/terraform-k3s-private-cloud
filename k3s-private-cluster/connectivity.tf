resource "aws_eip" "nat" {
  count = length(var.nat_gateways_subnets)

  vpc = true

  tags = {
    "Name" = "nat-${local.name}-${count.index}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = length(var.nat_gateways_subnets)

  allocation_id = element(aws_eip.nat, count.index).id
  subnet_id     = element(var.nat_gateways_subnets, count.index)

  tags = {
    "Name" = "nat-${local.name}-${count.index}"
  }
}

resource "aws_route_table" "nat" {
  count = length(var.nat_gateways_subnets)

  vpc_id = data.aws_vpc.nat.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat, count.index).id
  }

  tags = {
    "Name" = "nat-${local.name}-${count.index}"
  }
}

resource "aws_route_table_association" "nat" {
  count = length(var.nat_gateways_subnets)

  subnet_id      = element(var.nat_gateways_subnets, count.index)
  route_table_id = aws_route_table.nat.id
}

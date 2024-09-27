resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.sn_cidr
  availability_zone       = var.sn_az
  map_public_ip_on_launch = var.sn_is_public
  tags = {
    Name = var.sn_name
  }
}

resource "aws_route_table" "rt" {
  vpc_id = var.vpc_id
  dynamic "route" {
    for_each = var.rt_rules
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }

  tags = {
    Name = var.rt_name
  }
}

resource "aws_route_table_association" "rt-assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_eip" "nat-ip" {
  tags = {
    Name = "${var.nat_name}-ip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = var.nat_sn_id

  tags = {
    Name = var.nat_name
  }
}
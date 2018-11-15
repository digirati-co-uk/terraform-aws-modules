# VPC module

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    "Name"    = "${var.prefix}-vpc"
    "Project" = "${var.project}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_subnet" "public_1" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_public_1_cidr}"
  availability_zone = "${var.subnet_public_1_az}"

  map_public_ip_on_launch = true

  tags {
    "Name"    = "${var.prefix}-public-1"
    "Project" = "${var.project}"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_public_2_cidr}"
  availability_zone = "${var.subnet_public_2_az}"

  map_public_ip_on_launch = true

  tags {
    "Name"    = "${var.prefix}-public-2"
    "Project" = "${var.project}"
  }
}

resource "aws_route_table" "public_1" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    "Name" = "${var.prefix}-public-1"
  }
}

resource "aws_route_table" "public_2" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    "Name" = "${var.prefix}-public-2"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.public_1.id}"
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = "${aws_subnet.public_2.id}"
  route_table_id = "${aws_route_table.public_2.id}"
}

resource "aws_route" "public_1_internet_access" {
  route_table_id         = "${aws_route_table.public_1.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route" "public_2_internet_access" {
  route_table_id         = "${aws_route_table.public_2.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_eip" "nat" {
  vpc = true

  tags {
    "Name"    = "${var.prefix}-nat"
    "Project" = "${var.project}"
  }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_1.id}"

  tags {
    "Name"    = "${var.prefix}-nat"
    "Project" = "${var.project}"
  }

  depends_on = ["aws_internet_gateway.main"]
}

resource "aws_subnet" "private_1" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_private_1_cidr}"
  availability_zone = "${var.subnet_private_1_az}"

  map_public_ip_on_launch = false

  tags {
    "Name"    = "${var.prefix}-private-1"
    "Project" = "${var.project}"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.subnet_private_2_cidr}"
  availability_zone = "${var.subnet_private_2_az}"

  map_public_ip_on_launch = false

  tags {
    "Name"    = "${var.prefix}-private-2"
    "Project" = "${var.project}"
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    "Name"    = "${var.prefix}-private-1"
    "Project" = "${var.project}"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    "Name"    = "${var.prefix}-private-2"
    "Project" = "${var.project}"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.private_1.id}"
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = "${aws_subnet.private_2.id}"
  route_table_id = "${aws_route_table.private_2.id}"
}

resource "aws_route" "private_1_internet_access" {
  route_table_id         = "${aws_route_table.private_1.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw.id}"

  depends_on = ["aws_nat_gateway.gw"]
}

resource "aws_route" "private_2_internet_access" {
  route_table_id         = "${aws_route_table.private_2.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw.id}"

  depends_on = ["aws_nat_gateway.gw"]
}

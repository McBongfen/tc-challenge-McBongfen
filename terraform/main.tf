resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "subnet" {
  count = "${length(var.subnet_cidrs_public)}"

  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.subnet_cidrs_public[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.subnet-tag[count.index]}"
  }


}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}
resource "aws_route_table_association" "public" {
  count = "${length(var.subnet_cidrs_public)}"

  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_security_group" "sg" {
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags ={
    Name= "my-security-grp"
  }

}


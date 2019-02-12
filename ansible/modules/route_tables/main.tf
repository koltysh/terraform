resource "aws_route_table" "public-rt" {
    vpc_id = "${var.vpc_id}"

    route {
        cidr_block = "${var.cidr}"
        gateway_id = "${var.gateway_id}"
    }

    tags {
        Name = "${var.name}"
    }
}

resource "aws_route_table_association" "public-rt" {
    subnet_id = "${var.subnet_id}"
    route_table_id = "${aws_route_table.public-rt.id}"
}


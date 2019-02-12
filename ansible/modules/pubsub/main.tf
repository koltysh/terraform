resource "aws_subnet" "pubsub" {
    vpc_id = "${var.vpc_id}"
    cidr_block = "${var.cidr}"
    availability_zone = "${var.zone}"

    tags {
        Name = "${var.name}"
    }
}


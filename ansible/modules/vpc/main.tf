resource "aws_vpc" "terraform" {
    cidr_block = "${var.cidr}"
    enable_dns_hostnames = "true"
   
    tags {
        Name = "${var.name}"
    }
}


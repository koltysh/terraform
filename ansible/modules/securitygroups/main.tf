resource "aws_security_group" "tersg" {
  name = "vpc_test_ter"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["${var.cidr}"]
  }

  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["${var.cidr}"]
  }

  vpc_id="${var.vpc_id}"

  tags {
    Name = "${var.name}"
  }
}


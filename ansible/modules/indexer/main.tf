resource "aws_instance" "indexer"{
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    key_name = "1"
    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = ["${var.vpc_sg_id}"]
    associate_public_ip_address = true
    count = 2



 tags {
        Name = "${var.name}"
    }
  provisioner "remote-exec" {
    inline = [
      "sudo apt -y install python"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
   }
}

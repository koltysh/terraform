provider "aws" {
  region = "us-west-2"
}

# Define provider


# Define a VPC

resource "aws_vpc" "terraform" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "test-vpc"
  }
}

# Add public subnet

resource "aws_subnet" "public-subnet" {
  vpc_id            = "${aws_vpc.terraform.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "Public Subnet"
  }
}

# Define the internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.terraform.id}"

  tags {
    Name = "VPC IGW"
  }
}

# Define the route table

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.terraform.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}


# Assign the route table to the public Subnet

resource "aws_route_table_association" "public-rt" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}


# Define the security group for public subnet

resource "aws_security_group" "tersg" {
  name        = "vpc_test_ter"
  description = "Allow incoming HTTP connections & SSH access"

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

  vpc_id = "${aws_vpc.terraform.id}"

  tags {
    Name = "Terraform SG"
  }
}


# install search head instance

resource "aws_instance" "master"{
    ami                         = "${var.ami_id}"
    instance_type               = "${var.instype}"
    key_name                    = "1"
    subnet_id                   = "${aws_subnet.public-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.tersg.id}"]
    associate_public_ip_address = true
    private_ip                  = "${var.master_ip}"

           
 tags {
        Name = "Master"
    }
  provisioner "remote-exec" {
    inline = [
      "sudo apt -y install python"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.key_path)}"
    }
   }
/*  provisioner "local-exec" {
    command = "ansible-playbook -i inventory/ec2.py -e 'host_key_checking=False' play.yml" 
  }*/ 
}



# install indexer

resource "aws_instance" "indexer"{
    count                       = 2
    ami                         = "${var.ami_id}"
    instance_type               = "${var.instype}"
    key_name                    = "1"
    subnet_id                   = "${aws_subnet.public-subnet.id}"
    vpc_security_group_ids      = ["${aws_security_group.tersg.id}"]
    associate_public_ip_address = true
    
 
 tags {
        Name = "Indexer"
    }

  provisioner "remote-exec" {
    inline = [
      "sudo apt -y install python"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
  
      private_key = "${file(var.key_path)}"
      
    }
 } 
/*  provisioner "local-exec" {
    command = "ansible-playbook -i inventory/ec2.py -e 'host_key_checking=False' play.yml" 
  }*/ 
 }




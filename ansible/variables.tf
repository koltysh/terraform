variable "aws_region" {
  description = "Region for VPC"
  default = "us-west-2"
}
variable "ami_id" {
  description = "Ubuntu server 16.04 AMI"
  default = "ami-db710fa3"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}
variable "instype" {
  description = "Instance type"
  default = "t2.micro"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/vova/.ssh/id_rsa"
}

variable "master_ip" {
  description = "set up manualy private ip to master node"
  default = "10.0.1.100"
}

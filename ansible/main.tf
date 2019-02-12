provider "aws" {
  region = "us-west-2"
}

# Define a VPC

module "vpc"  {
  source = "./modules/vpc"
  
  name = "ter-vpc"
  cidr = "${var.vpc_cidr}"
}

# Add public subnet

module "pubsub" {
  source = "./modules/pubsub"
  
  vpc_id = "${module.vpc.id}"
  cidr   = "${var.public_subnet_cidr}"
  name   = "Splunk Public Subnet"
  zone   = "us-west-2a"
  
}

# Define the internet gateway

module "igateway" {
  source = "./modules/igateway"   
 
  vpc_id = "${module.vpc.id}"
  name   = "IGW" 
  
}


# Define the route table

module "route_tables" {
  source = "./modules/route_tables" 
  
  vpc_id     = "${module.vpc.id}"
  cidr       = "0.0.0.0/0"
  gateway_id = "${module.igateway.id}"
  name       = "Splunk Public Subnet RT" 
  subnet_id  = "${module.pubsub.id}"
}

 


# Define the security group for public subnet

module "securitygroups" {
 source = "./modules/securitygroups" 
  
   name   = "Terraform SG"
   cidr   = "0.0.0.0/0"
   vpc_id =  "${module.vpc.id}"


  
}


# install search head instance

module "masternode" {
  source = "./modules/masternode"
    
    ami           = "${var.ami_id}"
    instance_type = "${var.instype}"
    subnet_id     = "${module.pubsub.id}"
    vpc_sg_id     = "${module.securitygroups.id}"
    private_ip    = "${var.master_ip}"
    name          = "Master"
    private_key   = "${file(var.key_path)}"

}

# install indexer

module "indexer" {
  source = "./modules/indexer"

    ami           = "${var.ami_id}"
    instance_type = "${var.instype}"
    subnet_id     = "${module.pubsub.id}"
    vpc_sg_id     = "${module.securitygroups.id}"
    name          = "Indexer"
    private_key   = "${file(var.key_path)}"
}

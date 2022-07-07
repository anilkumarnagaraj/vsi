# VPC

data "ibm_resource_group" "rg" {
  name  = "default"
}

module "vpc" {
  source = "terraform-ibm-modules/vpc/ibm//modules/vpc"

  create_vpc        = "true"
  vpc_name          = "${var.course_prefix}-vpc"
  resource_group_id = data.ibm_resource_group.rg.id
}

module "subnet" {
  source = "terraform-ibm-modules/vpc/ibm//modules/subnet"
  name                = "${var.course_prefix}-subnet"
  vpc_id              = module.vpc.vpc_id[0]
  resource_group_id   = data.ibm_resource_group.rg.id
  location            = "us-south-1"
  number_of_addresses = 256
}


# VSI for VPC

data "ibm_is_image" "rhel7" {
  name = var.image
}

resource "tls_private_key" "example" {
  count     = 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "vpc_ssh" {
  name           = "${var.course_prefix}-ssh"
  resource_group = data.ibm_resource_group.rg.id
  public_key     = tls_private_key.example[0].public_key_openssh
}

module "vsi" {
  source                    = "terraform-ibm-modules/vpc/ibm//modules/instance"
  no_of_instances           = 1
  name                      = "${var.course_prefix}-vsi"
  vpc_id                    = module.vpc.vpc_id[0] 
  resource_group_id         = data.ibm_resource_group.rg.id
  location                  = "us-south-1"
  image                     = data.ibm_is_image.rhel7.id
  profile                   = var.profile
  ssh_keys                  = [ibm_is_ssh_key.vpc_ssh.id]
  primary_network_interface = local.primary_network_interface
}

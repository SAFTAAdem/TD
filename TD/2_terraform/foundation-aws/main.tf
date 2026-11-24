provider "aws" {
  region = var.region
}

module "foundation" {
  source         = "../modules/aws_foundation"
  region         = var.region
  instance_count = var.instance_count
  dns_name       = var.dns_name
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region
}

resource "aws_vpc" "primary-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

module "custom-sg" {
    source  = "app.terraform.io/kevindemos/custom-sg/aws"
    version = "1.0.0"

    description = "my moduled security group"
    identifier = "kevinc"
    vpc_id = aws_vpc.primary-vpc.id
}

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region
}

module "custom-vpc" {
    source  = "app.terraform.io/kevindemos/custom-vpc/aws"
    version = "1.0.1"

    aws_region = var.aws_region
}

module "custom-sg" {
    source  = "app.terraform.io/kevindemos/custom-sg/aws"
    version = "1.0.1"

    description = "my moduled security group"
  identifier = var.identifier
    vpc_id = module.custom-vpc.id
}

module "dynamodb" {
    source  = "app.terraform.io/kevindemos/dynamodb/aws"
    version = "1.0.0"

  identifier = var.identifier
    key_setup = {
        hashkey = {
            keyname = "MyHash"
            keydata = "S"
        }
        rangekey = {
            keyname = "MyRange"
            keydata = "S"
        }
    }
}

module "iam-role" {
    source  = "app.terraform.io/kevindemos/iam-role/aws"
    version = "1.0.2"

  identifier = var.identifier
    actions = [
        "ec2:*",
        "s3:*",
        "dynamodb:*",
        "ssm:UpdateInstanceInformation",
        "ssm:ListInstanceAssociations",
        "ssm:ListAssociations",
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
    ]
}

module "my-nginx" {
  source  = "app.terraform.io/kevindemos/my-nginx/aws"
  version = "1.0.2"

  identifier = var.identifier
  key_pair = var.key_pair
  instance_size = "t3.micro"
  profile_id = module.iam-role.profile_id
  sg_id = module.custom-sg.id
  subnet_id = module.custom-vpc.subnet_id
}

module "my-bucket" {
  source  = "app.terraform.io/kevindemos/my-bucket/aws"
  version = "1.0.0"

  identifier = var.identifier
}

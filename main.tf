provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region
}

module "custom-vpc" {
    source  = "app.terraform.io/kevindemos/custom-vpc/aws"
    version = "1.0.0"

    aws_region = var.aws_region
}

module "custom-sg" {
    source  = "app.terraform.io/kevindemos/custom-sg/aws"
    version = "1.0.1"

    description = "my moduled security group"
    identifier = "kevinc"
    vpc_id = module.custom-vpc.id
}

module "dynamodb" {
    source  = "app.terraform.io/kevindemos/dynamodb/aws"
    version = "1.0.0"

    identifier = "kevinc"
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
    version = "1.0.0"

    identifier = "kevinc"
    action = [
        "ec2:*",
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

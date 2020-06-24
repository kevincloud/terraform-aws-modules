provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.aws_region
}

module "custom-vpc" {
    source  = "app.terraform.io/${var.organization}/custom-vpc/aws"

    aws_region = var.aws_region
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
    }
}

module "custom-sg" {
    source  = "app.terraform.io/${var.organization}/custom-sg/aws"

    description = "my moduled security group"
    identifier = var.identifier
    vpc_id = module.custom-vpc.id
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
    }
}

module "dynamodb" {
    source  = "app.terraform.io/${var.organization}/dynamodb/aws"

    identifier = var.identifier
    encryption = false
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
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
    }
}

module "iam-role" {
    source  = "app.terraform.io/${var.organization}/iam-role/aws"

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
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
    }
}

module "my-nginx" {
    source  = "app.terraform.io/${var.organization}/my-nginx/aws"

    identifier = var.identifier
    key_pair = var.key_pair
    instance_size = "t3.micro"
    profile_id = module.iam-role.profile_id
    sg_id = module.custom-sg.id
    subnet_id = module.custom-vpc.subnet_id
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
    }
}

module "my-bucket" {
    source  = "app.terraform.io/${var.organization}/my-bucket/aws"

    identifier = var.identifier
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
    }
}

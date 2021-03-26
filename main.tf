provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    token = var.aws_session_token
    region = var.aws_region
}

module "custom-vpc" {
    source  = "app.terraform.io/kevindemos/custom-vpc/aws"

    aws_region = var.aws_region
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
        Owner = var.owner
        Region = var.hc_region
        Purpose = var.purpose
        TTL = var.ttl
    }
}

module "custom-sg" {
    source  = "app.terraform.io/kevindemos/custom-sg/aws"

    description = "my moduled security group"
    identifier = var.identifier
    vpc_id = module.custom-vpc.id
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
        Owner = var.owner
        Region = var.hc_region
        Purpose = var.purpose
        TTL = var.ttl
    }
}

module "dynamodb" {
    source  = "app.terraform.io/kevindemos/dynamodb/aws"

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
        Owner = var.owner
        Region = var.hc_region
        Purpose = var.purpose
        TTL = var.ttl
    }
}

module "iam-role" {
    source  = "app.terraform.io/kevindemos/iam-role/aws"

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
        Owner = var.owner
        Region = var.hc_region
        Purpose = var.purpose
        TTL = var.ttl
    }
}

module "my-nginx" {
    source  = "app.terraform.io/kevindemos/my-nginx/aws"

    identifier = var.identifier
    key_pair = var.key_pair
    instance_size = "t3.micro"
    profile_id = module.iam-role.profile_id
    sg_id = module.custom-sg.id
    subnet_id = module.custom-vpc.subnet_id
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
        Owner = var.owner
        Region = var.hc_region
        Purpose = var.purpose
        TTL = var.ttl
    }
}

module "my-bucket" {
    source  = "app.terraform.io/kevindemos/my-bucket/aws"

    identifier = var.identifier
    tags = {
        Department = "Solutions Engineering"
        Environment = "Development"
        Owner = var.owner
        Region = var.hc_region
        Purpose = var.purpose
        TTL = var.ttl
    }
}

resource "aws_vpc" "primary-vpc" {
    cidr_block = "10.10.0.0/16"
}

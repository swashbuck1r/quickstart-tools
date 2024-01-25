terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.5"
    }
  }

  required_version = "~> 1.5"

#   backend "s3" {
#     # TODO: change this bucket your own AWS bucket to store terraform state
#     bucket         = "cb-arch-infra"
#     key            = "terraform/cloudbees-terraform-example/state.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state"
#   }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      TerraformSource = "infra"
    }
  }
}


data "aws_s3_bucket" "my_bucket" {
  bucket = "cloudbees-infra-tf-state"
}

output "my_bucket" {
  value = data.aws_s3_bucket.my_bucket
}
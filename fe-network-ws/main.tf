
terraform {
  cloud {
    organization = "vpc-wf-org"

    workspaces {
      name = "fe-network-ws"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
  }
}

provider "aws" {
  region = var.aws-region
}


terraform {
  cloud {
    organization = "vpc-peering"

    workspaces {
      name = "fe-compute-ws"
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
  region = data.terraform_remote_state.vpc.outputs["aws-region"]
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "vpc-peering"
    workspaces = {
      name = "fe-network-ws"
    }
  }
}
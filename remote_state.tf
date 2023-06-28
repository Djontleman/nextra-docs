data "terraform_remote_state" "shared" {
  backend = "remote"

  config = {
    organization = "jhutchinson531"
    workspaces = {
      name = "nextra-docs"
    }
  }
}

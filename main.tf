terraform {
  cloud {
    organization = "jhutchinson531"

    workspaces {
      name = "nextra-docs"
    }
  }
  required_version = "~> 1.5.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.45.0"
    }
    vercel = {
      source  = "vercel/vercel"
      version = "0.13.2"
    }
  }
}

data "tfe_outputs" "vercel" {
  organization = "jhutchinson531"
  workspace    = "nextra-docs"
}

provider "vercel" {
  api_token = var.vercel_api_token
}

resource "vercel_project" "nextra_docs" {
  name      = "nextra-docs"
  framework = "nextjs"
}

data "vercel_project_directory" "nextra_docs" {
  path = "."
}

resource "vercel_deployment" "nextra_docs" {
  project_id  = data.terraform_remote_state.shared.outputs.vercel_project_id
  files       = data.vercel_project_directory.nextra_docs.files
  path_prefix = data.vercel_project_directory.nextra_docs.path
  production  = var.is_prod
}

output "vercel_project_id" {
  value     = vercel_project.nextra_docs.id
  sensitive = true
}

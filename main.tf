terraform {
  cloud {
    organization = "jhutchinson531"

    workspaces {
      name = "nextra-docs"
    }
  }
  required_version = "~> 1.5.0"
  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = "0.13.2"
    }
  }
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
  project_id  = vercel_project.nextra_docs.id
  files       = data.vercel_project_directory.nextra_docs.files
  path_prefix = data.vercel_project_directory.nextra_docs.path
  production  = true
}

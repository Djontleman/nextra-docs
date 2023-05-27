terraform {
  required_providers {
    vercel = {
      source = "vercel/vercel"
      version = "~> 0.4"
    }
  }
}

resource "vercel_project" "nextra_docs" {
  name      = "nextra-docs"
  framework = "nextjs"
}

data "vercel_project_directory" "nextra_docs" {
  path = ".."
}

resource "vercel_deployment" "nextra_docs" {
  project_id  = vercel_project.nextra_docs.id
  files       = data.vercel_project_directory.nextra_docs.files
  path_prefix = ".."
  production  = true
}
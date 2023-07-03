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
  count     = var.is_prod ? 1 : 0
  name      = "nextra-docs"
  framework = "nextjs"
}

output "vercel_project_id" {
  description = "Vercel project ID"
  value       = length(vercel_project.nextra_docs) > 0 ? vercel_project.nextra_docs[0].id : null
  sensitive   = false
}

data "vercel_project_directory" "nextra_docs" {
  path = "."
}

resource "vercel_deployment" "nextra_docs" {
  project_id  = data.tfe_outputs.vercel.values.vercel_project_id
  files       = data.vercel_project_directory.nextra_docs.files
  path_prefix = data.vercel_project_directory.nextra_docs.path
  production  = var.is_prod
}

output "preview_domain" {
  description = "Preview URL for Vercel deployment"
  value       = vercel_deployment.nextra_docs.url
}

output "prod_domain" {
  description = "Prod domain for Vercel project"
  value       = is_prod ? element(vercel_deployment.nextra_docs.domains, 0) : null
}

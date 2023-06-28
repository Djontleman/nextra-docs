variable "vercel_api_token" {
  description = "Vercel API token"
  type        = string
  sensitive   = true
}

variable "is_prod" {
  description = "If false, deploy Preview environment. If true, deploy Production environment"
  default     = false
}

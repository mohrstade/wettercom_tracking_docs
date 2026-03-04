variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region (used for regional resources)"
  type        = string
  default     = "europe-west1"
}

variable "bucket_name" {
  description = "GCS bucket name for static site files (must be globally unique)"
  type        = string
}

variable "domain" {
  description = "Domain for the documentation site (e.g. tracking-docs-demo.buchert.digital)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in owner/repo format (e.g. MoritzMohrStade/tracking_docs)"
  type        = string
}

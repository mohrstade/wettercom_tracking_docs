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

variable "iap_oauth2_client_id" {
  description = "OAuth 2.0 client ID created manually in GCP Console (APIs & Services → Credentials)"
  type        = string
}

variable "iap_oauth2_client_secret" {
  description = "OAuth 2.0 client secret created manually in GCP Console"
  type        = string
  sensitive   = true
}

variable "iap_members" {
  description = "Additional IAP members beyond domain:wetter.com, in IAM member format (e.g. [\"user:moritz@mohrstade.de\"])"
  type        = list(string)
  default     = []
}

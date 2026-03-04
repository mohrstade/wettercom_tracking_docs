output "load_balancer_ip" {
  description = "Point your DNS A record for the domain at this IP address"
  value       = google_compute_global_address.site.address
}

output "workload_identity_provider" {
  description = "Set this as the WIF_PROVIDER secret in GitHub Actions"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "service_account_email" {
  description = "Set this as the WIF_SERVICE_ACCOUNT secret in GitHub Actions"
  value       = google_service_account.github_actions.email
}

output "bucket_name" {
  description = "Set this as the GCS_BUCKET secret in GitHub Actions"
  value       = google_storage_bucket.site.name
}

output "proxy_image" {
  description = "Set this as the PROXY_IMAGE secret in GitHub Actions (Artifact Registry image path)"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.proxy.repository_id}/proxy"
}

output "cloudrun_service" {
  description = "Cloud Run service name (for gcloud run deploy)"
  value       = google_cloud_run_v2_service.proxy.name
}

output "cloudrun_region" {
  description = "Cloud Run service region (for gcloud run deploy)"
  value       = var.region
}

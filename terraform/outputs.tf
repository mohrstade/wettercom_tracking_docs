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

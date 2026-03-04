# Note: The IAP OAuth brand and client must be created manually via the GCP Console.
# The IAP OAuth Admin APIs (google_iap_brand / google_iap_client) were restricted
# for new projects on January 19, 2026 and are non-functional.
#
# Setup steps:
#   1. APIs & Services → OAuth consent screen → Internal → fill in app name + support email
#   2. APIs & Services → Credentials → Create OAuth 2.0 Client ID (Web application)
#   3. Set iap_oauth2_client_id and iap_oauth2_client_secret in terraform.tfvars

# Grant all @wetter.com users access
resource "google_iap_web_backend_service_iam_member" "domain" {
  project             = var.project_id
  web_backend_service = google_compute_backend_service.site.name
  role                = "roles/iap.httpsResourceAccessor"
  member              = "domain:wetter.com"
}

# Grant additional individual users access (e.g. user:moritz@mohrstade.de)
resource "google_iap_web_backend_service_iam_member" "extra_users" {
  for_each = toset(var.iap_members)

  project             = var.project_id
  web_backend_service = google_compute_backend_service.site.name
  role                = "roles/iap.httpsResourceAccessor"
  member              = each.value
}

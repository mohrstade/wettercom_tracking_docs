resource "google_storage_bucket" "site" {
  name                        = var.bucket_name
  location                    = "EU"
  force_destroy               = false
  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  depends_on = [google_project_service.apis]
}

# The Load Balancer serves the bucket publicly — no direct public access needed.
# GitHub Actions (via the service account) gets objectAdmin via iam.tf.

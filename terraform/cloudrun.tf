# Artifact Registry repository for the proxy Docker image
resource "google_artifact_registry_repository" "proxy" {
  repository_id = "tracking-docs-proxy"
  location      = var.region
  format        = "DOCKER"
  description   = "Docker images for the GCS proxy serving the tracking docs site"

  depends_on = [google_project_service.apis]
}

# Service account for the Cloud Run proxy
resource "google_service_account" "cloudrun" {
  account_id   = "tracking-docs-proxy"
  display_name = "Tracking Docs Proxy"
  description  = "Used by the Cloud Run proxy to read files from the GCS site bucket"
}

# Allow Cloud Run SA to read files from the site bucket
resource "google_storage_bucket_iam_member" "cloudrun_reader" {
  bucket = google_storage_bucket.site.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.cloudrun.email}"
}

# Cloud Run proxy service
resource "google_cloud_run_v2_service" "proxy" {
  name     = "tracking-docs-proxy"
  location = var.region

  # Only allow traffic from the load balancer (not directly from the internet)
  ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    service_account = google_service_account.cloudrun.email

    containers {
      # On first apply, use a placeholder image. The deploy-proxy workflow will
      # update this to the real image once the Artifact Registry repo exists.
      image = "gcr.io/cloudrun/hello"

      env {
        name  = "BUCKET_NAME"
        value = google_storage_bucket.site.name
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.apis]

  lifecycle {
    # Prevent Terraform from overwriting the image after deploy-proxy updates it
    ignore_changes = [template[0].containers[0].image]
  }
}

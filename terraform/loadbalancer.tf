# Static global IP — point your DNS A record here after apply
resource "google_compute_global_address" "site" {
  name       = "tracking-docs-ip"
  depends_on = [google_project_service.apis]
}

# Backend bucket with Cloud CDN enabled
resource "google_compute_backend_bucket" "site" {
  name        = "tracking-docs-backend"
  bucket_name = google_storage_bucket.site.name
  enable_cdn  = true

  cdn_policy {
    cache_mode       = "CACHE_ALL_STATIC"
    client_ttl       = 3600
    default_ttl      = 3600
    max_ttl          = 86400
    negative_caching = true
  }
}

# Google-managed SSL certificate
resource "google_compute_managed_ssl_certificate" "site" {
  name = "tracking-docs-ssl"

  managed {
    domains = [var.domain]
  }

  depends_on = [google_project_service.apis]
}

# URL map for HTTPS traffic
resource "google_compute_url_map" "site" {
  name            = "tracking-docs-url-map"
  default_service = google_compute_backend_bucket.site.id
}

# URL map for HTTP → HTTPS redirect
resource "google_compute_url_map" "https_redirect" {
  name = "tracking-docs-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }

  depends_on = [google_project_service.apis]
}

# HTTPS proxy
resource "google_compute_target_https_proxy" "site" {
  name             = "tracking-docs-https-proxy"
  url_map          = google_compute_url_map.site.id
  ssl_certificates = [google_compute_managed_ssl_certificate.site.id]
}

# HTTP proxy (redirect only)
resource "google_compute_target_http_proxy" "redirect" {
  name    = "tracking-docs-http-proxy"
  url_map = google_compute_url_map.https_redirect.id
}

# Forwarding rule: HTTPS
resource "google_compute_global_forwarding_rule" "https" {
  name                  = "tracking-docs-https"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.site.id
  ip_address            = google_compute_global_address.site.id
}

# Forwarding rule: HTTP (redirects to HTTPS)
resource "google_compute_global_forwarding_rule" "http" {
  name                  = "tracking-docs-http"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.redirect.id
  ip_address            = google_compute_global_address.site.id
}

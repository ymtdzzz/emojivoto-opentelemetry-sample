resource "google_compute_subnetwork" "custom" {
  project = var.project_id
  name          = "${var.app_name}-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.custom.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }
}

resource "google_compute_network" "custom" {
  project = var.project_id
  name                    = "${var.app_name}-network"
  auto_create_subnetworks = false
}

resource "google_service_account" "default" {
  project = var.project_id
  account_id   = var.app_name
  display_name = "service account for ${var.app_name}"
}

resource "google_container_cluster" "primary" {
  project = var.project_id
  name     = "${var.app_name}-cluster"
  location = var.region
  node_locations = [ "${var.region}-a" ]

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.custom.id
  subnetwork = google_compute_subnetwork.custom.id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "services-range"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  project = var.project_id
  name       = "${var.app_name}-node-pool"
  location   = var.region
  node_locations = [ "${var.region}-a" ]
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    spot  = true
    machine_type = "n1-standard-1"

    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

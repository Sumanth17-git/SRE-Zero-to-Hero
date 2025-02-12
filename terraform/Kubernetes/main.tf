provider "google" {
  project = "artful-talon-443506-d1" # Replace with your GCP project ID
  region  = "us-central1"       # Replace with your preferred region
  zone    = "us-central1-a"    # Replace with your preferred zone
}
resource "google_container_cluster" "primary" {
  name                       = "gke-cluster"
  location                   = "us-central1-a"
  initial_node_count         = 1
  remove_default_node_pool   = true
}

resource "google_container_node_pool" "primary_node_pool" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = "us-central1-a"

  node_config {
    machine_type = var.machine_type

    # Set disk size and type
    disk_size_gb = 80
    disk_type    = "pd-ssd"

    # Configure labels and tags if needed
    tags = ["k8s-node"]
  }

  # Fixed number of nodes
node_count = 1 # Current number of nodes  
  # Autoscaling configuration
  #autoscaling {
  #  min_node_count = 1
  #  max_node_count = 2  # Maximum nodes allowed in the pool
  #}

   lifecycle {
    create_before_destroy = true # Ensures new node pool is created before deleting the old one
  }
}
variable "machine_type" {
  default = "e2-standard-4"
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}
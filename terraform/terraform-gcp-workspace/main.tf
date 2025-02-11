terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.19.0"
    }
  }
}
locals {
  project_id       = terraform.workspace == "dev" ? "aiops-447509" : "praxis-citron-447508-f8"
  credentials_file = terraform.workspace == "dev" ? "C:/Training/terraform_projects/aiops-447509-c2d18fc9ac92.json" : "C:/Training/terraform_projects/praxis-citron-447508-f8-dc005b866fc4.json"
}

provider "google" {
  credentials = file(local.credentials_file)
  project = local.project_id
  region  = var.region

}


resource "google_storage_bucket" "bucket" {
  name     = "${var.bucket_prefix}-${terraform.workspace}"
  location = var.region
}
resource "google_compute_instance" "vm_instance" {
  for_each = { for vm in var.vms : vm.name => vm }

  name         = "${each.value.name}-${terraform.workspace}"
  machine_type = each.value.machine_type
  zone         = each.value.zone #  Now uses per-VM zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = each.value.image
    }
  }

  scheduling {
    preemptible        = each.value.spot_instance # Enable/disable spot instances
    provisioning_model = each.value.spot_instance ? "SPOT" : "STANDARD" # Ensure correct model
    automatic_restart  = !each.value.spot_instance # Disable auto-restart for spot instances
  }

  labels = each.value.labels # Apply labels correctly

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  tags = ["http-server", "https-server"]

  lifecycle {
    create_before_destroy = true  # Ensures new instance is created before destroying the old one
  }
}
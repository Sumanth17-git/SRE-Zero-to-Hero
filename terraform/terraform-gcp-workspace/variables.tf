variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "bucket_prefix" {
  description = "Prefix for the GCS bucket name"
  type        = string
}



variable "vms" {
  description = "List of VMs to create"
  type = list(object({
    name         = string
    zone         = string 
    machine_type = string
    image        = string
    spot_instance = bool
    labels       = map(string)
  }))
  default = []
}
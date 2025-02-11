# production.tfvars
project_id    = "praxis-citron-447508-f8"
bucket_prefix = "prod-bucket"


# List of VMs to create
vms = [
  {
    name         = "api-server"
    machine_type = "e2-micro"
    image        = "debian-cloud/debian-11"
    zone          = "us-east4-a"
    spot_instance = false  # Enable spot instance for dev
    labels = {
      environment = "prod"
      team        = "api-server"
    }
  },
  {
    name         = "recos-server"
    machine_type = "e2-micro"
    image        = "debian-cloud/debian-11"
    zone          = "us-central1-a"
    spot_instance = false  # Enable spot instance for dev
    labels = {
      environment = "production"
      team        = "mlops"
    }
  },
]
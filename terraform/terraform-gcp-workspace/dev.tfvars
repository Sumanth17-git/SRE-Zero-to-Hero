project_id    = "aiops-447509"
bucket_prefix = "dev-bucket"


# List of VMs to create
vms = [
  {
    name         = "springboot-server"
    machine_type = "e2-micro"
    image        = "debian-cloud/debian-11"
    zone          = "us-central1-a"
    spot_instance = true  # Enable spot instance for dev
    labels = {
      environment = "dev"
      team        = "development"
    }
  },
  {
    name         = "recos-server"
    machine_type = "e2-micro"
    image        = "debian-cloud/debian-11"
    zone          = "us-central1-a"
    spot_instance = false  # Standard VM
    labels = {
      environment = "dev"
      team        = "operations"
    }
  },
  {
    name         = "db-server"
    machine_type = "e2-micro"
    image        = "debian-cloud/debian-11"
    zone          = "us-east4-a"
    spot_instance = true  # Standard VM
    labels = {
      environment = "platform"
      team        = "operations"
    }
  }
]

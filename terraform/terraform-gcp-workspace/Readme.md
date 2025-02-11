**Project: Terraform Infrastructure Deployment on GCP**

This project automates the provisioning of **Google Cloud Platform (GCP) resources** using **Terraform**. It enables the deployment of **Compute Engine Virtual Machines (VMs) in multiple regions and zones**, with support for **Spot (preemptible) and Standard instances**. The project also manages a **Cloud Storage bucket**, using **Terraform Workspaces** for different environments (e.g., dev and production).

**Project Features**

- **Terraform Workspaces**: Supports dev and production environments.
- **Google Compute Engine (GCE) Instances**:
  - Creates multiple **VM instances** dynamically.
  - Supports **Spot (preemptible) instances** for cost savings.
  - Assigns different **zones** to each VM.
  - Adds **custom labels** for better organization.
- **Google Cloud Storage (GCS) Bucket**:
  - Creates a **storage bucket** with a custom prefix for each workspace.
- **Dynamic Configuration**:
  - Each environment (dev or production) uses different **GCP projects and credentials**.
  - Uses **for_each** to dynamically create multiple VM instances from a list.

**Folder Structure**

terraform-gcp-infra/

│── main.tf # Main Terraform configuration

│── variables.tf # Input variables for Terraform

│── dev.tfvars # Variables for the development environment

│── production.tfvars # Variables for the production environment (example)

│── README.md # Project documentation

│── .gitignore # Ignore sensitive files like credentials

│── terraform.tfstate # Terraform state file (not committed)

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

**Pre-requisites**

1. Authenticate GCP CLI:
Ensure your **GCP project** is set up and has:
    - Compute Engine API enabled
    - Cloud Storage API enabled
    - IAM permissions for the Terraform service account
# Step-by-Step Setup
**Step 1: Clone the Repository**
```bash
git clone https://github.com/Sumanth17-git/SRE-Zero-to-Hero.git
cd terraform/terraform-gcp-workspace
```
**Step 2: Initialize Terraform**
terraform init

**Step 3: Select Workspace**
Terraform uses **workspaces** to manage multiple environments (dev, production).
- To create/select the **dev** environment:
```bash
terraform workspace new dev
terraform workspace select dev
```
For **production**:
```bash
terraform workspace new production
terraform workspace select production
```
**Step 4: Plan the Deployment**
Run the Terraform plan command to preview the changes
```bash
terraform plan -var-file=dev.tfvars
```
This will show which resources will be created in the **development** environment.

**Step 5: Apply the Terraform Configuration**
To create the infrastructure, run:
```bash
terraform apply -var-file=dev.tfvars -auto-approve
```
- This will create:
  - A **GCS Bucket** (dev-bucket-dev)
  - **Compute Engine VMs** based on dev.tfvars:
    - springboot-server in us-central1-a (Spot Instance)
    - recos-server in us-east1-b (Standard Instance)
**Step 6: Verify in GCP Console**

After applying, go to:

- **Compute Engine → VM Instances** to check your VMs.
- **Cloud Storage → Buckets** to verify the created storage bucket.

**Step 7: Destroy the Infrastructure (Optional)**

To remove the infrastructure:
```bash
terraform destroy -var-file=dev.tfvars -auto-approve
```
**Configuration Details**

**Terraform Workspaces**

- **terraform.workspace** is used to differentiate environments.
- Based on the selected workspace (dev or production), the correct **GCP project ID** and **credentials file** are assigned dynamically.

**Compute Engine VM Configurations**

- Defined in dev.tfvars with:
  - **Name, machine type, image**
  - **Region & Zone** (each VM can have different locations)
  - **Spot (preemptible) option**
  - **Custom labels**
Example (dev.tfvars):

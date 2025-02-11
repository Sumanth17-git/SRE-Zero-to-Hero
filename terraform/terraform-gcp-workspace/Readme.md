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

# Pre-requisites

1. **Create two GCP projects**
<img width="515" alt="image" src="https://github.com/user-attachments/assets/7b477bac-8a36-45d1-a9a1-e4424adab6e1" />

2.**Authenticate GCP CLI:**
Ensure your **GCP project** is set up and has:
    - Compute Engine API enabled
    - Cloud Storage API enabled
    - IAM permissions for the Terraform service account
    
2.**Create IAM Service Account on both gcp project and generate the json key file and store it in secret place.**
    ## **1️⃣ Go to the GCP Console**
    - Navigate to the **[Google Cloud Console](https://console.cloud.google.com/)**.
    ## **2️⃣ Access IAM & Admin**
    - In the **left-hand menu**, click on **IAM & Admin**.
    ## **3️⃣ Create a Service Account**
    - Click on **Service Accounts**.
    - Click the **+ Create Service Account** button at the top.
    ## **4️⃣ Provide Service Account Details**
    - **Service Account Name**: Enter a name (e.g., `terraform-sa`).
    - Click **Create and Continue**.
    ## **5️⃣ Assign a Role**
    - In the **Select a Role** dropdown, choose **Editor**.
    - Click **Continue**.
    ## **6️⃣ Complete the Process**
    - Click **Done** to finish creating the service account.
    ## ✅ **Next Steps**
    - Generate a **JSON Key** to use this service account for Terraform authentication.
      - Click on the **Service Account**.
      - Go to the **Keys** tab.
      - Click **Add Key > Create New Key**.
      - Choose **JSON** and click **Create**.
      - Download the **JSON file** and store it securely.
    
    🚀 Now, you can use this service account for **Terraform deployments in GCP**!

# Step-by-Step Setup
**Step 1: Clone the Repository**
```bash
git clone https://github.com/Sumanth17-git/SRE-Zero-to-Hero.git
cd terraform/terraform-gcp-workspace
```
**Now Update the main.tf with new json key and project_id according to your both projects as like below**
```bash
locals {
  project_id       = terraform.workspace == "dev" ? "aiops-447509" : "praxis-citron-447508-f8"
  credentials_file = terraform.workspace == "dev" ? "C:/Training/terraform_projects/aiops-447509-c2d18fc9ac92.json" : "C:/Training/terraform_projects/praxis-citron-447508-f8-dc005b866fc4.json"
}
```
**Step 2: Initialize Terraform**
```bash
terraform init
```
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
```bash
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
```
You can add a new VM's 

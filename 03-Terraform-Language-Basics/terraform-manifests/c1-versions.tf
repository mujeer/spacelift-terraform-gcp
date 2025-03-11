# Terraform Settings Block
terraform {
  required_version = ">= 1.10.5"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 6.20.0"
    }
  }
}

# Terraform Provider Block
provider "google" {
  project = "imposing-muse-421813" # PROJECT_ID
  region = "us-central1"
}


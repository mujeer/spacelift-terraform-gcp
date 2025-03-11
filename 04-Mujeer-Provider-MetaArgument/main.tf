terraform {
  required_version = "~> 1.10.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.20.0"
    }
  }
}

provider "google" {
  project = "imposing-muse-421813"
  region  = "us-east1"
  alias   = "us-east1"

}
provider "google" {
  project = "imposing-muse-421813"
  region  = "us-central1"
  alias   = "us-central1"

}
resource "google_compute_network" "myvpc_1" {
  name = "vpc1"
  auto_create_subnetworks = false   
  provider = google.us-east1
}

resource "google_compute_network" "myvpc_2" {
  name = "vpc2"
  auto_create_subnetworks = false
  provider = google.us-central1 
}


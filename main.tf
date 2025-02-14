terraform {
  required_version = "~> 1.5.7"
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 6.20.0"
    }
  }
}

provider "google" {
    project = "imposing-muse-421813"
  
}

resource "google_compute_network" "mujeer_vpc" {
    name = "mujeer"
  
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.mujeer_vpc.id
#   secondary_ip_range {
#     range_name    = "tf-test-secondary-range-update1"
#     ip_cidr_range = "192.168.10.0/24"
#   }
}

resource "google_compute_address" "example-ip" {
  name   = "nginx"
  region = "us-central1"
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"
  network_interface {
    subnetwork = google_compute_subnetwork.network-with-private-secondary-ip-ranges.id
    network = google_compute_network.mujeer_vpc.name
    access_config {
      nat_ip = google_compute_address.example-ip.address  # Static IP
    }
    
  }
  metadata_startup_script = file("./nginx.sh")

  tags = ["ssh-tag", "webserver-tag"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
        }
      }
   }
}

# Firewall Rule: SSH
resource "google_compute_firewall" "fw_ssh" {
  name = "fwrule-allow-ssh22"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.mujeer_vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-tag"]
}

# Firewall Rule: HTTP Port 80
resource "google_compute_firewall" "fw_http" {
  name = "fwrule-allow-http80"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.mujeer_vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver-tag"]
}
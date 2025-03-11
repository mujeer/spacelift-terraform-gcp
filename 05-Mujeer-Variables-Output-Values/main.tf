terraform {
  required_version = "~> 1.10.5"
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 6.20.0"
    }
  }
}

provider "google" {
    project = var.gcp_project
    region = var.gcp_region
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = var.machine_type
  zone         = "us-east1-b"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

}

output "instance_name" {
    value = google_compute_instance.default.name
  
}

output "vm_instanceid" {
    value = google_compute_instance.default.instance_id
}
/*
output "vm_selflink" {
    value = google_compute_instance.default.vm_selflink
  
}
*/
output "vm_id" {
    value = google_compute_instance.default.id
  
}
output "vm_machine_type" {
    value = google_compute_instance.default.machine_type
  
}
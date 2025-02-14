# Resource Block: Create a single Compute Engine instance
resource "google_compute_instance" "myapp1" {
  name         = "myapp1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags        = [tolist(google_compute_firewall.fw_ssh.target_tags)[0], tolist(google_compute_firewall.fw_http.target_tags)[0]]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  # Install Webserver
  metadata_startup_script = <<-EOF
  #!/bin/bash
  sudo apt install -y telnet
  sudo apt install -y nginx
  sudo systemctl enable nginx
  sudo systemctl start nginx 
  sudo chmod -R 755 /var/www/html
  sudo mkdir -p /var/www/html/app1
  HOSTNAME=$(hostname)
  sudo echo "<!DOCTYPE html> <html> <body style='background-color:rgb(250, 210, 210);'> <h1>Welcome to StackSimplify - WebVM App1 </h1> <p><strong>VM Hostname:</strong> $HOSTNAME</p> <p><strong>VM IP Address:</strong> $(hostname -I)</p> <p><strong>Application Version:</strong> V1</p> <p>Google Cloud Platform - Demos</p> </body></html>" | sudo tee /var/www/html/app1/index.html
  sudo echo "<!DOCTYPE html> <html> <body style='background-color:rgb(250, 210, 210);'> <h1>Welcome to StackSimplify - WebVM App1 </h1> <p><strong>VM Hostname:</strong> $HOSTNAME</p> <p><strong>VM IP Address:</strong> $(hostname -I)</p> <p><strong>Application Version:</strong> V1</p> <p>Google Cloud Platform - Demos</p> </body></html>" | sudo tee /var/www/html/index.html
  EOF
  network_interface {
    subnetwork = google_compute_subnetwork.mysubnet.id 
    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

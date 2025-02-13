# Terraform Provider Configuration: google
provider "google" {
  project = "imposing-muse-421813"
  region = var.region
}

# Resource: VPC
resource "google_compute_network" "myvpc" {
  name =  var.vpc_name
  auto_create_subnetworks = false   
}

# Resource: Subnet
resource "google_compute_subnetwork" "mysubnet" {
  name          =  var.subnet_name
  region        =  var.region
  ip_cidr_range =  var.cidr
  network       = google_compute_network.myvpc.id  // GET VPC ID
}

variable "vpc_name" {
  type = string
  default = "vpc1"
  
}
variable "subnet_name" {
  type = string
  default = "subnet1"
  
}
variable "region" {
  type = string
  default = "us-central1"
  
  
}
variable "cidr" {
  type = string
  default = "10.128.0.0/20"
}



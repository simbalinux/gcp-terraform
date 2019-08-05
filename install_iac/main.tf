provider "google" { 
  credentials = "${file("project-11009.key.json")}"   # -- change this
  project = "project-11009"			      # -- change this
  region = "us-west1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
 name         = "flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-west1-a"


 provisioner "file" {
    source      = "../app.py"
    destination = "$HOME/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/app.py",
      "python $HOME/app.py",
    ]
  }
 metadata = {
    ssh-keys = "vagrant:${file("~/.ssh/id_rsa.pub")}"   # -- ensure local keys exist || fail
  }
 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync tmux; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}


resource "google_compute_firewall" "default" {
 name    = "flask-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["5000"]
 }
}


// A variable for extracting the external ip of the instance
output "ip" {
 value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}


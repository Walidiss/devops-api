terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }

  # State stocké dans Object Storage Hetzner (S3-compatible)
  backend "s3" {
    bucket = "devops-tfstate"
    key    = "hetzner/terraform.tfstate"
    region = "us-east-1" # format valide (valeur ignorée)
    endpoints = {
      s3 = "https://hel1.your-objectstorage.com"
    }
    access_key                  = "R0KHK1O22MF9ZXSST9F4"
    secret_key                  = "5MHyro0Ul3EZrqOhcGPYPddUet4N6jadTOKVgQ1D"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true # ← AJOUT : évite l'appel STS/IAM vers AWS
    use_path_style              = true # ← REMPLACEMENT : force_path_style est déprécié

  }
}
provider "hcloud" {
  token = var.hcloud_token
}
# Clé SSH enregistrée dans Hetzner
data "hcloud_ssh_key" "main" {
  name = "issaoui.walid@live.fr" # nom exact dans Hetzner
}

# Le VPS lui-même
resource "hcloud_server" "vps" {
  name        = "devops-vps"
  image       = "ubuntu-24.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [data.hcloud_ssh_key.main.id] # référence le data source
  # Script exécuté au premier boot
  user_data = <<-EOF
    #!/bin/bash
    apt update && apt install -y docker.io curl
    systemctl enable docker && systemctl start docker
    curl -sfL https://get.k3s.io | sh -
    ufw allow 22 && ufw allow 80 && ufw allow 443 && ufw allow 6443
    ufw --force enable
  EOF
  labels = {
    env     = "production"
    project = "devops-demo"
  }
}
# Firewall Hetzner (en plus de UFW)
resource "hcloud_firewall" "main" {
  name = "devops-firewall"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80-443"
    source_ips = ["0.0.0.0/0"]
  }
}
resource "hcloud_firewall_attachment" "main" {
  firewall_id = hcloud_firewall.main.id
  server_ids  = [hcloud_server.vps.id]
}
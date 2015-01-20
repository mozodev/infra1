resource "digitalocean_droplet" "web" {
  image = "ubuntu-14-04-x64"
  name = "${var.domain}"
  region = "sgp1"
  size = "512mb"
  backups = "false"
  ssh_keys = ["${var.ssh_fingerprint}"]
  connection {
    user = "root"
    key_file = "${var.pvt_key}"
    timeout = "2m"
  }
  provisioner "local-exec" {
    command = "echo \"[default]\n${digitalocean_droplet.web.ipv4_address} >> hosts\""
  }
}

output "address_web" {
  value = "${digitalocean_droplet.web.ipv4_address}"
}
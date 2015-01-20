# Create a new domain record
resource "digitalocean_domain" "default" {
  name = "${var.domain}"
  ip_address = "${digitalocean_droplet.web.ipv4_address}"
}

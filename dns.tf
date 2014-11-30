# Create a new domain record
resource "digitalocean_domain" "default" {
  name = "${var.domain}"
  ip_address = "${digitalocean_droplet.web.ipv4_address}"
}

# Add a record to the domain
resource "digitalocean_record" "www" {
  domain = "${digitalocean_domain.default.name}"
  type = "CNAME"
  name = "www"
  value = "@"
}
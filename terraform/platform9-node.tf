provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_droplet" "p9-k8s-node" {
  name = "${format("p9-k8s-%02d.${var.region}", count.index)}"
  image = "ubuntu-14-04-x64"
  size  = "${var.size}"
  count = "${var.count}
  ssh_keys = ["${var.ssh_key_fingerprint}"]
  connection {
    user = "root"
    private_key = "${file("${var.priv_ssh_key_path}"
  }
  provisioner "file" {
    source = "files/platform9-install-k8s-debian.sh"
    destination = "/root/platform9-install-k8s-debian.sh"
  }
  provisioner "remote-exec" {
  	inline = "chmod +x /root/platform9-install-k8s-debian.sh; sh /root/platform9-install-k8s-debian.sh" 
  }
}

resource "digitalocean_loadbalancer" "public" {
  name = "p9-lb.${var.region}"
  region = "${var.region}"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 30061
    target_protocol = "http"
  }

  healthcheck {
    port = 30061
    protocol = "http"
  }

  droplet_ids = ["${digitalocean_droplet.p9-k8s-00.${var.region}.id}"]
}

resource "digitalocean_floating_ip" "foobar" {
  droplet_id = "${digitalocean_droplet.p9-k8s-00.${var.region}.id}"
  region     = "${var.region}"
}
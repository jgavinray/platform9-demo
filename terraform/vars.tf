variable "digitalocean_token" {
  description = "Your DigitalOcean API key"
}

variable "ssh_key_fingerprint" {
  description = "Your SSH Public Key"
}

variable "region" {
  description = "DigitalOcean Region"
  default = "sfo2"
}

variable "size" {
  description = "node size"
  default = "4GB"
}

variable "count" {
  default = "3"
  description = "Number of nodes. 1, 3, or 5."
}

variable "ssh_public_key_path" {
  description = "Path to your public SSH key path"
  default = "./do-key.pub"
}

variable "priv_ssh_key_path" {
  description = "Path to your private SSH key for the project"
  default = "./do-key"
}

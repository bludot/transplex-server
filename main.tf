terraform {
  required_version = ">= 0.13"
  required_providers {
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
      #
      # For more information, see the provider source documentation:
      # https://github.com/josenk/terraform-provider-esxi
      # https://registry.terraform.io/providers/josenk/esxi
    }
  }
}

provider "esxi" {
  esxi_hostname      = var.esxi_hostname
  esxi_hostport      = var.esxi_hostport
  esxi_hostssl       = var.esxi_hostssl
  esxi_username      = var.esxi_username
  esxi_password      = var.esxi_password
}

data "template_file" "userdata" {
  template = "${file("userdata.yaml")}"
  vars = {
    username = var.username
    ssh_key_pub = var.ssh_key_pub
    plex_ip = var.plex_ip
    hostname = "${var.guest_name}"
  }
}

data "template_file" "metadata" {
  template = "${file("metadata.yaml")}"
  vars = {
    gateway_ip = var.gateway_ip 
    static_ip = var.transmission_ip
  }
}

resource "esxi_guest" "master" {
  guest_name         = var.guest_name
  disk_store         = "datastore2"

  memsize = 4096
  boot_disk_size = 150
  ovf_source        = "focal-server-cloudimg-amd64.ova"

  network_interfaces {
    virtual_network = "internal_apps"
  }
  guestinfo = {
    "metadata" = base64gzip("${data.template_file.metadata.rendered}")
    "metadata.encoding" = "gzip+base64"
    userdata = base64gzip("${data.template_file.userdata.rendered}")
    "userdata.encoding" = "gzip+base64"
  }
  provisioner "local-exec" {
    command = <<EOT
        echo "test"
        EOT
  }
}

output "userdata" {
  value = "${data.template_file.userdata.rendered}"
}

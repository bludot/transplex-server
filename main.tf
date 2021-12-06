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

data "template_file" "master_userdata" {
  template = "${file("userdata.yaml")}"
  vars = {
    username = var.username
    ssh_key_pub = var.ssh_key_pub
    ssh_key_priv = var.ssh_key_priv
    hostname = "${var.guest_name}-master"
  }
}

data "template_file" "master_metadata" {
  template = "${file("metadata.yaml")}"
  vars = {
    gateway_ip = var.gateway_ip 
    static_ip = var.master_ip
  }
}

resource "esxi_guest" "master" {
  guest_name         = var.guest_name
  disk_store         = "datastore2"

  ovf_source        = "focal-server-cloudimg-amd64.ova"

  network_interfaces {
    virtual_network = "internal_apps"
  }
  guestinfo = {
    "metadata" = base64gzip("${data.template_file.master_metadata.rendered}")
    "metadata.encoding" = "gzip+base64"
    userdata = base64gzip("${data.template_file.master_userdata.rendered}")
    "userdata.encoding" = "gzip+base64"
  }
  provisioner "local-exec" {
    command = <<EOT
        echo "test"
        EOT
  }
}


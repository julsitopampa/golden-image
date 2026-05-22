packer {
  required_version = ">= 1.15.0"
  description      = "Template for the debian based AMI, foundation of my linux infra"
  required_plugins = {
    
  }
}

source "proxmox-iso" "debian" {
  boot_iso {
    iso_urls      = ["https://ftp.crifo.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso","https://ftp.crifo.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"]
    iso_checksums = "file:https://ftp.crifo.org/debian-cd/current/amd64/iso-cd/SHA512SUMS"
    type          = "scsi"
    unmount       = true

  }

  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]

  boot_wait   = "10s"

  onboot      = true
  qemu_agent  = true
  os          = "l26"
  machine     = "q35"
  scsi_controller = "virito-scsi-single"

  memory              = "${var.memory}"
  ballooning_minimum  = "${var.memory}"

  cores     = "${var.cores}"
  cpu_type  = "host"
  sockets   = 1
  numa      = true

  disks {
    disk_size         = "${var.disk_size}"
    storage_pool      = "${var.storage_pool}"
    type              = "virtio"
    cache_mode        = "writethrough"
    io_thread         = true
    discard           = true
    ssd               = true
  }

  bios = "ovmf"

  efi_config {
    efi_storage_pool  = "${var.storage_pool}"
    efi_type          = "4m"
    pre_enrolled_keys = false
    efi_format        = "raw"
  }

  tpm_config {
    tpm_storage_pool  = "${var.storage_pool}"
    tpm_version       = "2.0"
  }

  rng0 {
      source    = "/dev/urandom"
      max_bytes = 1024
      period    = 1000
  }

  network_adapters {
    bridge        = "vmbr0"
    model         = "virtio"
    vlan_tag      = "0"
    firewall      = false
    packet_queues = "${var.cores}"
  }

  http_directory           = "./http"
  cloud_init               = true
  cloud_init_storage_pool  = "${var.storage_pool}"
  cloud_init_disk_type     = "scsi"
  insecure_skip_tls_verify = true

  node                 = "pve1"
  username             = "${var.proxmox_api_token_id}"
  token                = "${var.proxmox_api_token_secret}"
  proxmox_url          = "${var.proxmox_api_url}"
  vm_name              = "debian-ozonions"
  vm_id                = 9999
  tags                 = "template"

  ssh_private_key_file = "~/.ssh/id_ed25519"
  ssh_timeout          = "15m"
  ssh_username         = "provisioner"

  template_description = "Debian 13.1, generated on ${timestamp()}"
  template_name        = "Debian-13 (ozonions)"
}

build {
  sources = ["source.proxmox-iso.debian"]
}

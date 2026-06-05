packer {
  required_version = ">= 1.15.0"
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "debian" {
  boot_iso {
    iso_urls         = ["https://ftp.crifo.org/debian-cd/current/amd64/iso-cd/debian-13.5.0-amd64-netinst.iso"]
    iso_checksum     = "file:https://ftp.crifo.org/debian-cd/current/amd64/iso-cd/SHA512SUMS"
    type             = "ide"
    unmount          = true
    iso_storage_pool = "local"
  }

  boot_command = [
    # Select the first menu entry ("Install") — it is already highlighted by default.
    # Press 'e' to enter GRUB edit mode for that entry.
    "e<wait2>",

    # The GRUB edit screen shows the full menuentry stanzas.
    # The cursor lands at the top of the entry. We need to reach the 'linux' line.
    # The linux line is typically the 3rd line of the entry.
    # <down> moves one line, <end> jumps to end of that line.
    "<down><down><down><end><wait>",

    # Append all kernel parameters after the existing line content.
    # A leading space is mandatory — without it the last existing parameter
    # and the first new one get concatenated into one broken token.
    " auto=true priority=critical",
    " locale=fr_FR.UTF-8",
    " keymap=fr",
    " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
    " interface=auto",
    " netcfg/get_hostname=debian-golden",
    " netcfg/get_domain=localdomain",
    " DEBIAN_FRONTEND=text",

    # <ctrl-x> or <F10> boots the modified entry.
    "<leftCtrlOn>x<leftCtrlOff>"
  ]

  boot_wait = "10s"

  onboot          = true
  qemu_agent      = true
  os              = "l26"
  machine         = "q35"
  scsi_controller = "virtio-scsi-single"

  memory             = "${var.memory}"
  ballooning_minimum = "${var.memory}"

  cores    = "${var.cores}"
  cpu_type = "host"
  sockets  = 1
  numa     = true

  disks {
    disk_size    = "${var.disk_size}"
    storage_pool = "${var.storage_pool}"
    type         = "scsi"
    cache_mode   = "writethrough"
    io_thread    = true
    discard      = true
    ssd          = true
  }

  bios = "ovmf"

  efi_config {
    efi_storage_pool  = "${var.storage_pool}"
    efi_type          = "4m"
    pre_enrolled_keys = false
    efi_format        = "raw"
  }

  tpm_config {
    tpm_storage_pool = "${var.storage_pool}"
    tpm_version      = "v2.0"
  }

  rng0 {
    source    = "/dev/urandom"
    max_bytes = 1024
    period    = 1000
  }

  network_adapters {
    bridge        = "vmbr0"
    model         = "virtio"
    firewall      = false
    packet_queues = "${var.cores}"
    mac_address   = "BC:24:11:27:BF:E6"
  }

  insecure_skip_tls_verify = true

  http_directory = "http"
  http_bind_address = var.http_bind_address
  http_port_min     = var.http_port_min
  http_port_max     = var.http_port_max

  node        = "pve1"
  username    = "${var.proxmox_api_token_id}"
  token       = "${var.proxmox_api_token_secret}"
  proxmox_url = "${var.proxmox_api_url}"
  vm_name     = "debian-golden"
  vm_id       = 9999
  tags        = "template"

  ssh_timeout  = "15m"
  ssh_username = "provisioner"
  ssh_password = "debian"

  template_description = "Debian 13.1, generated on ${timestamp()}"
  template_name        = "debian-golden"
}

build {
  sources = ["source.proxmox-iso.debian"]
}

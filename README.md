# Golden Image (Debian 13 Trixie — Proxmox VE)

Automated Packer pipeline building a CIS-hardened **Debian 13 (Trixie)** VM template (`vm_id = 9999`) on Proxmox VE for homelab deployments.

## Architecture & Features

- **Base OS**: Debian 13 (Trixie) netinst (`amd64`), French locale (`fr_FR.UTF-8`) and French console/TTY keymap (`fr` / `Latin9`).
- **Hardware Profile**:
  - UEFI (`ovmf` 4M) + TPM v2.0 (`q35` machine, `virtio-scsi-single`, VirtIO RNG)
  - 4 vCPU (`host`), 4096 MB RAM, 40 GB SCSI disk (`discard`, `ssd`, `io_thread`)
  - QEMU Guest Agent enabled (`qemu-guest-agent`)
- **CIS LVM Partitioning (`http/preseed.cfg`)**:
  - GPT layout with 512 MB EFI + 512 MB `/boot` + LVM Volume Group (`vg0`)
  - Dedicated logical volumes with hardened mount options (`nodev`, `nosuid`, `noexec`) for `/`, `swap`, `/tmp`, `/var`, `/var/tmp`, `/var/log`, `/var/log/audit`, and `/home`
- **Network & DHCP Consistency (No Cloud-Init)**:
  - Uses a deterministic build MAC (`var.mac_address`) during Packer builds so the ISP DHCP server always assigns the same IP.
  - Configures DHCP (`dhclient` and `systemd-networkd`) to send the hardware MAC address (`ClientIdentifier=mac`) instead of DUID.
  - Sysprep truncates `/etc/machine-id` and clears DHCP leases before converting to a template so downstream Terraform clones obtain unique IPs based on their assigned MAC addresses.
- **CIS Hardening (`ansible/`)**:
  - Hardened via [ansible-lockdown/DEBIAN13-CIS](https://github.com/ansible-lockdown/DEBIAN13-CIS) targeting **CIS Level 1 Server** (`level1-server`).
  - Preserves the `provisioner` user with SSH and passwordless sudo access for post-clone Terraform provisioning.

## Usage

### 1. Install Ansible dependencies
```bash
ansible-galaxy role install -r ansible/requirements.yml -p ansible/roles
ansible-galaxy collection install -r ansible/requirements.yml
```

### 2. Initialize and Validate Packer
```bash
packer init .
packer fmt -check .
packer validate .
```

### 3. Build Template
```bash
export PKR_VAR_proxmox_api_token_secret="<your-token-secret>"
packer build -force .
```

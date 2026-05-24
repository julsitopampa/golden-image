variable "proxmox_api_url" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "provisioner_password_hash" {
  type        = string
  description = <<-EOT
    SHA-512 crypt hash of the provisioner user password.
    Generate with: openssl passwd -6 'yourpassword'
  EOT
  sensitive   = true
}

variable "provisioner_ssh_pubkey" {
  type      = string
  sensitive = true
}

variable "cores" {
  type    = number
  default = 4
}

variable "memory" {
  type    = number
  default = 4096
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "disk_size" {
  type    = string
  default = "20G"
}

variable "boot_mb" {
  type        = number
  default     = 512
  description = "/boot partition size in MB. Lives outside LVM as a primary partition."
}

variable "lv_root_pct" {
  type        = number
  default     = 20.5
  description = "Percentage of LVM VG allocated to LV root (mountpoint: /)."

  validation {
    condition     = var.lv_root_pct >= 1 && var.lv_root_pct <= 100
    error_message = "Must be between 1% and 100% and the total of all lv_*_pct must be also between 1% and 100%."
  }
}

variable "lv_tmp_pct" {
  type        = number
  default     = 5.1
  description = "Percentage of LVM VG allocated to LV tmp (mountpoint: /tmp)."

  validation {
    condition     = var.lv_tmp_pct >= 1 && var.lv_tmp_pct <= 100
    error_message = "Must be between 1% and 100% and the total of all lv_*_pct must be also between 1% and 100%."
  }
}

variable "lv_var_pct" {
  type        = number
  default     = 20.5
  description = "Percentage of LVM VG allocated to LV var (mountpoint: /var)."

  validation {
    condition     = var.lv_var_pct >= 1 && var.lv_var_pct <= 100
    error_message = "Must be between 1% and 100% and the total of all lv_*_pct must be also between 1% and 100%."
  }
}

variable "lv_vartmp_pct" {
  type        = number
  default     = 5.1
  description = "Percentage of LVM VG allocated to LV vartmp (mountpoint: /var/tmp)."

  validation {
    condition     = var.lv_vartmp_pct >= 1 && var.lv_vartmp_pct <= 100
    error_message = "Must be between 1% and 100% and the total of all lv_*_pct must be also between 1% and 100%."
  }
}

variable "lv_varlog_pct" {
  type        = number
  default     = 10.3
  description = "Percentage of LVM VG allocated to LV varlog (mountpoint: /var/log)."

  validation {
    condition     = var.lv_varlog_pct >= 1 && var.lv_varlog_pct <= 100
    error_message = "Must be between 1% and 100% and the total of all lv_*_pct must be also between 1% and 100%."
  }
}

variable "lv_audit_pct" {
  type        = number
  default     = 5.1
  description = "Percentage of LVM VG allocated to LV audit (mountpoint: /var/log/audit)."

  validation {
    condition     = var.lv_audit_pct >= 1 && var.lv_audit_pct <= 100
    error_message = "Must be between 1% and 100% and the total of all lv_*_pct must be also between 1% and 100%."
  }
}

variable "lv_home_pct" {
  type        = number
  default     = 10.3
  description = "Percentage of LVM VG allocated to LV home (mountpoint: /home)."

  validation {
    condition     = var.lv_home_pct >= 1 && var.lv_home_pct <= 100
    error_message = "Must be between 1% and 100% and the total of all lv_*_pct must be also between 1% and 100%."
  }
}

variable "lv_swap_pct" {
  type        = number
  default     = 5.1
  description = "Percentage of LVM VG allocated to LV swap."

  validation {
    condition     = var.lv_swap_pct >= 1 && var.lv_swap_pct <= 100
    error_message = "Must be between 1% and 100% and the total of all lv_*_pct must be also between 1% and 100%."
  }
}

variable "http_port_min" {
  type        = number
  default     = 8100
  description = "Lower bound of the port range for Packer's built-in HTTP server."
}

variable "http_port_max" {
  type        = number
  default     = 8200
  description = "Upper bound of the port range for Packer's built-in HTTP server."
}

variable "http_bind_address" {
  type        = string
  default     = "0.0.0.0"
  description = "Address Packer's HTTP server binds to. Must be reachable from the Proxmox VM network."
}



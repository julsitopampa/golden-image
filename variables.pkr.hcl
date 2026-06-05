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
  default = "40G"
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



variable "proxmox_api_url" {
    type = string
    sensitive = true
}

variable "proxmox_api_token_id" {
    type = string
    sensitive = true
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "cores" {
    type = number
    default = 4
}

variable "memory" {
    type = number
    default = 4096
}

variable "storage_pool" {
    type = string
    default = "local-lvm"
}

variable "disk_size" {
    type = number
    default = 30
}



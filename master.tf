resource "proxmox_virtual_environment_vm" "k8s-master" {
  name      = "k8s-master"
  node_name = "pve5"

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true

  template = false
  description = "simple template"

  machine = "q35"
  bios = "ovmf"
  
  memory {
    dedicated = 2048
  }

  initialization {
    user_account {
      # do not use this in production, configure your own ssh key instead!
      username = "ubuntu"
      password = "password"
      keys = [trimspace(data.local_file.ssh_public_key.content)]
    }
    ip_config {
        ipv4 {
            address = "192.168.1.77/24"
            gateway = "192.168.1.1"
        }
    }
  }
  network_device {
    bridge = "vmbr0"
  }

    
  disk {
    datastore_id = "local-lvm"
    file_id  = proxmox_virtual_environment_download_file.centos_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }
}

resource "proxmox_virtual_environment_vm" "k8s-worker" {
  name      = "k8s-worker"
  node_name = "pve5"

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true

  template = false
  description = "simple template"

  machine = "q35"
  bios = "ovmf"
  
  memory {
    dedicated = 2048
  }

  initialization {
    user_account {
      # do not use this in production, configure your own ssh key instead!
      username = "ubuntu"
      password = "password"
      keys = [trimspace(data.local_file.ssh_public_key.content)]
    }
    ip_config {
        ipv4 {
            address = "192.168.1.78/24"
            gateway = "192.168.1.1"
        }
    }
  }
  network_device {
    bridge = "vmbr0"
  }

    
  disk {
    datastore_id = "local-lvm"
    file_id  = proxmox_virtual_environment_download_file.centos_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }
}

data "local_file" "ssh_public_key" {
  filename = "./ssh/k8s2.pub"
}

resource "proxmox_virtual_environment_download_file" "centos_cloud_image" {
  content_type = "iso"
  datastore_id = "pveFS"
  node_name    = "pve5"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}
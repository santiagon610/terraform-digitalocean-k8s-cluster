variable "region" {
  description = "Digital Ocean region in which to build cluster"
  type        = string
  default     = "nyc1"
}

variable "vpc_uuid" {
  description = "VPC UUID in which to build cluster"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Descriptive name of k8s cluster"
  type        = string
  default     = "k8s"
}

variable "k8s_version" {
  description = "Version of k8s control plane to use"
  type        = string
  default     = ""
}

variable "k8s_auto_upgrade" {
  description = "Automatically upgrade k8s control plane?"
  type        = bool
  default     = true
}

variable "do_registry_integration" {
  description = "Integrate cluster with DO registry?"
  type        = bool
  default     = true
}

variable "initial_node_pool" {
  description = "Configuration for initial node pool"
  type = object({
    name       = string
    min_nodes  = number
    max_nodes  = number
    size       = string
    auto_scale = bool
    labels     = map(string)
  })
  default = {
    name       = "initial"
    min_nodes  = 1
    max_nodes  = 2
    size       = "s-4vcpu-8gb"
    auto_scale = true
    labels = {
      managed-by   = "terraform"
      purpose      = "default"
      droplet-size = "s-4vcpu-8gb"
    }
  }
}

variable "additional_node_pools" {
  description = "Configuration for additional node pools"
  type = map(object({
    min_nodes  = number
    max_nodes  = number
    size       = string
    auto_scale = bool
    labels     = map(string)
  }))
  default = {}
}

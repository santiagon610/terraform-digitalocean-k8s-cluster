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

variable "nodepool01_min" {
  description = "Minimum count of nodes for nodepool01"
  type        = number
  default     = 2
}

variable "nodepool01_max" {
  description = "Maximum count of nodes for nodepool01"
  type        = number
  default     = 4
}

variable "enable_nodepool02" {
  description = "Enable secondary node pool?"
  type        = bool
  default     = true
}

variable "nodepool02_min" {
  description = "Minimum count of nodes for nodepool02"
  type        = number
  default     = 1
}

variable "nodepool02_max" {
  description = "Maximum count of nodes for nodepool02"
  type        = number
  default     = 4
}

variable "nodepool01_dropletsize" {
  description = "Type of droplet to use for nodepool01"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "nodepool02_dropletsize" {
  description = "Type of droplet to use for nodepool02"
  type        = string
  default     = "s-4vcpu-8gb"
}

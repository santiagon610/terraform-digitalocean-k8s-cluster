resource "digitalocean_kubernetes_cluster" "this" {
  name                 = var.cluster_name
  region               = var.region
  vpc_uuid             = var.vpc_uuid
  version              = var.k8s_version
  auto_upgrade         = var.k8s_auto_upgrade
  registry_integration = var.do_registry_integration

  node_pool {
    name       = "${var.cluster_name}-nodepool01"
    size       = var.nodepool01_dropletsize
    auto_scale = true
    min_nodes  = var.nodepool01_min
    max_nodes  = var.nodepool01_max
    labels = {
      "managed_by" = "terraform"
      "tf_module"  = "k8s_bg_cluster"
      "node_size"  = "s-1vcpu-2gb"
    }
  }
  maintenance_policy {
    day        = "any"
    start_time = "04:00"
  }
}

locals {
  kubeconfig_yaml = digitalocean_kubernetes_cluster.this.kube_config[0].raw_config
  kubeconfig_hcl  = yamldecode(local.kubeconfig_yaml)
}

resource "digitalocean_kubernetes_node_pool" "nodepool02" {
  count      = var.enable_nodepool02 ? 1 : 0
  name       = "${var.cluster_name}-nodepool02"
  cluster_id = digitalocean_kubernetes_cluster.this.id
  size       = var.nodepool02_dropletsize
  auto_scale = true
  min_nodes  = var.nodepool02_min
  max_nodes  = var.nodepool02_max
}

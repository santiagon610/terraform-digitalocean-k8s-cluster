resource "digitalocean_kubernetes_cluster" "this" {
  name                 = var.cluster_name
  region               = var.region
  vpc_uuid             = var.vpc_uuid
  version              = var.k8s_version
  auto_upgrade         = var.k8s_auto_upgrade
  registry_integration = var.do_registry_integration

  node_pool {
    name       = "${var.cluster_name}-${var.initial_node_pool.name}"
    size       = var.initial_node_pool.size
    auto_scale = var.initial_node_pool.auto_scale
    min_nodes  = var.initial_node_pool.min_nodes
    max_nodes  = var.initial_node_pool.max_nodes
    labels     = var.initial_node_pool.labels
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

resource "digitalocean_kubernetes_node_pool" "additional" {
  for_each   = var.additional_node_pools
  name       = "${var.cluster_name}-${each.key}"
  cluster_id = digitalocean_kubernetes_cluster.this.id
  size       = each.value.size
  auto_scale = each.value.auto_scale
  min_nodes  = each.value.min_nodes
  max_nodes  = each.value.max_nodes
  labels     = each.value.labels
}
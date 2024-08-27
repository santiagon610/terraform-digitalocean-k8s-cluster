locals {
  k8s_version        = length(var.k8s_version) > 0 ? var.k8s_version : data.digitalocean_kubernetes_versions.this.latest_version
  auto_upgrade_flag  = length(var.k8s_version) == 0 ? true : false
  maintenance_policy = local.auto_upgrade_flag == true ? [var.maintenance_policy] : []
}

data "digitalocean_kubernetes_versions" "this" {}

resource "digitalocean_kubernetes_cluster" "this" {
  name                 = var.cluster_name
  region               = var.region
  vpc_uuid             = var.vpc_uuid
  version              = local.k8s_version
  auto_upgrade         = local.auto_upgrade_flag
  registry_integration = var.do_registry_integration
  tags                 = var.cluster_tags

  node_pool {
    name       = "${var.cluster_name}-${var.initial_node_pool.name}"
    size       = var.initial_node_pool.size
    auto_scale = var.initial_node_pool.auto_scale
    min_nodes  = var.initial_node_pool.min_nodes
    max_nodes  = var.initial_node_pool.max_nodes
    labels     = var.initial_node_pool.labels
  }

  dynamic "maintenance_policy" {
    for_each = local.maintenance_policy
    content {
      start_time = maintenance_policy.value.start_time
      day        = maintenance_policy.value.day
    }
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
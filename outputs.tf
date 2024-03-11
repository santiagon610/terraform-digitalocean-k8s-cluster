output "kubeconfig" {
  value = {
    hcl  = local.kubeconfig_hcl
    yaml = local.kubeconfig_yaml
  }
}

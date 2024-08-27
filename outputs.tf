output "kubeconfig" {
  description = "Kubernetes configuration for the cluster, provided in HCL and YAML."
  sensitive   = false
  value = {
    hcl  = local.kubeconfig_hcl
    yaml = local.kubeconfig_yaml
  }
}

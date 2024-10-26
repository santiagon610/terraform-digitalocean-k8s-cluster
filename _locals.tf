locals {
  argocd_project_config = {
    namespace  = kubernetes_namespace_v1.infra["argocd"].metadata[0].name
    helm_repo  = "${path.root}/../../charts"
    helm_chart = "raw-2.0.0"
    helm_source_repos = [
      "https://git.coreinfra.cloud/coreinfra/argo-apps.git",
      "https://charts.inl.io/",
      "https://sdbx-charts.inlv2.com/",
      "https://dev-charts.inlv2.com/",
      "https://test-charts.inlv2.com/",
    ]
    namespace_labels = {
      managed_by = "terraform"
    }
  }
}

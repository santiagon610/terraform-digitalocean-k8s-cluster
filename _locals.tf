locals {
  argo_project_config = {
    namespace  = kubernetes_namespace_v1.infra["argocd"].metadata[0].name
    helm_repo  = "${path.root}/../../charts"
    helm_chart = "raw-2.0.0"
    helm_source_repos = [
      "https://git.coreinfra.cloud/coreinfra/argo-apps.git",
      "https://github.com/tckgroup/infra-argo.git"
    ]
    namespace_labels = {
      managed_by = "terraform"
    }
  }
}

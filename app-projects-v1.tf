resource "kubernetes_namespace_v1" "app" {
  for_each = toset(var.app_projects)
  metadata {
    name = each.key
    labels = {
      "managed_by"              = "terraform"
      "inl.io/all-secrets"      = "please"
      "inl.io/managed-postgres" = "true"
    }
  }
}

resource "helm_release" "app_argocd_project" {
  for_each   = toset(var.app_projects)
  name       = "argocd-app-project-${each.key}"
  namespace  = local.argocd_project_config.namespace
  repository = local.argocd_project_config.helm_repo
  chart      = local.argocd_project_config.helm_chart
  values = [
    yamlencode({
      resources = [
        {
          apiVersion = "argoproj.io/v1alpha1"
          kind       = "AppProject"
          metadata = {
            name      = each.key
            namespace = local.argocd_project_config.namespace
          }
          annotations = {
            "notifications.argoproj.io/subscribe.on-sync-succeeded.slack" = "#alerts-infra-internal"
          }
          spec = {
            destinations = [
              {
                name      = "in-cluster"
                namespace = each.key
              }
            ]
            sourceRepos = ["*"]
          }
        }
      ]
      }
    )
  ]
  depends_on = [
    helm_release.argocd
  ]
}

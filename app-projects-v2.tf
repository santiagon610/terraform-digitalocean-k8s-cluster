resource "kubernetes_namespace_v1" "app_v2" {
  for_each = var.app_projects_v2
  metadata {
    name = each.key
    labels = {
      "managed_by"         = "terraform"
      "inl.io/all-secrets" = "please"
    }
  }
}

resource "helm_release" "app_argocd_project_v2" {
  for_each   = var.app_projects_v2
  name       = "argocd-app-project-v2-${each.key}"
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
            finalizers = concat(
              lookup(each.value, "finalizers", []),
              ["resources-finalizer.argocd.argoproj.io"]
            )
          }
          annotations = lookup(each.value, "annotations", {})
          spec = {
            syncPolicy = {
              syncOptions = lookup(each.value, "syncOptions", [
                "CreateNamespace=true"
              ])
              managedNamespaceMetadata = {
                labels      = lookup(each.value, "managedNamespaceMetadata", {})
                annotations = lookup(each.value, "managedNamespaceAnnotations", {})
              }
            }
            destinations = [
              {
                name      = "in-cluster"
                namespace = each.key
              }
            ]
            sourceRepos = concat(
              local.argocd_project_config.helm_source_repos,
              lookup(each.value, "sourceRepos", [])
            )
            clusterResourceWhitelist   = lookup(each.value, "clusterResourceWhiteList", [])
            namespaceResourceBlacklist = lookup(each.value, "namespaceResourceBlacklist", [])
            namespaceResourceWhitelist = lookup(each.value, "namespaceResourceWhitelist", [
              {
                group = "*"
                kind  = "*"
              }
            ])
            roles = lookup(each.value, "customRoles", [])
          }
        }
      ]
    })
  ]
  depends_on = [
    helm_release.argocd
  ]
}

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

resource "kubernetes_namespace_v1" "app" {
  for_each = toset(var.app_projects)
  metadata {
    name = each.key
    labels = {
      managed_by           = "terraform"
      external-secrets-inl = "please"
    }
  }
}

resource "helm_release" "app_argo_project" {
  for_each   = toset(var.app_projects)
  name       = "argocd-app-project-${each.key}"
  namespace  = local.argo_project_config.namespace
  repository = local.argo_project_config.helm_repo
  chart      = local.argo_project_config.helm_chart
  values = [
    yamlencode({
      resources = [
        {
          apiVersion = "argoproj.io/v1alpha1"
          kind       = "AppProject"
          metadata = {
            name      = each.key
            namespace = local.argo_project_config.namespace
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

resource "kubernetes_namespace_v1" "app_v2" {
  for_each = var.app_projects_v2
  metadata {
    name = each.key
    labels = {
      managed_by           = "terraform"
      external-secrets-inl = "please"
    }
  }
}

resource "helm_release" "app_argo_project_v2" {
  for_each   = var.app_projects_v2
  name       = "argocd-app-project-v2-${each.key}"
  namespace  = local.argo_project_config.namespace
  repository = local.argo_project_config.helm_repo
  chart      = local.argo_project_config.helm_chart
  values = [
    yamlencode({
      resources = [
        {
          apiVersion = "argoproj.io/v1alpha1"
          kind       = "AppProject"
          metadata = {
            name      = each.key
            namespace = local.argo_project_config.namespace
            finalizers = concat(
              lookup(each.value, "finalizers", []),
              ["resources-finalizer.argocd.argoproj.io"]
            )
          }
          annotations = lookup(each.value, "annotations", {})
          spec = {
            destinations = [
              {
                name      = "in-cluster"
                namespace = each.key
              }
            ]
            sourceRepos = concat(
              local.argo_project_config.helm_source_repos,
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

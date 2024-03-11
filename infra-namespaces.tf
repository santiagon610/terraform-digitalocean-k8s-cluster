locals {
  infra_namespaces = [
    "authentik", # cumulus/backlog#54
    "awx",       # cumulus/backlog#71
    "argocd",
    "external-secrets",
    "inl-infra"
  ]
}

resource "kubernetes_namespace_v1" "infra" {
  for_each = toset(local.infra_namespaces)

  metadata {
    name = each.key
    labels = {
      managed_by           = "terraform"
      external-secrets-inl = "please"
    }
  }
}

resource "helm_release" "infra_argo_project" {
  for_each   = toset(local.infra_namespaces)
  name       = "argocd-infra-project-${each.key}"
  namespace  = kubernetes_namespace_v1.infra["argocd"].metadata[0].name
  repository = "https://bedag.github.io/helm-charts/"
  chart      = "raw"
  version    = "2.0.0"
  values = [<<-EOF
    resources:
      - apiVersion: argoproj.io/v1alpha1
        kind: AppProject
        metadata:
          name: ${each.key}
          namespace: argocd
        annotations:
          notifications.argoproj.io/subscribe.on-sync-succeeded.slack: "#alerts-infra-internal"
        spec:
          destinations:
            - name: in-cluster
              namespace: '*'
              server: https://kubernetes.default.svc
          sourceRepos:
            - '*'
          clusterResourceWhitelist:
            - group: '*'
              kind: '*'
          namespaceResourceWhiteList:
            - group: '*'
              kind: '*'
    EOF
  ]
  depends_on = [
    helm_release.argocd
  ]
}

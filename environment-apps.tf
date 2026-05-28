resource "helm_release" "argocd_apps_env" {
  for_each   = var.argocd_environments
  name       = "argocd-apps-${each.key}"
  namespace  = kubernetes_namespace_v1.infra["argocd"].metadata[0].name
  repository = "https://bedag.github.io/helm-charts/"
  chart      = "raw"
  version    = "2.0.0"
  values = [<<-EOF
    resources:
      - apiVersion: argoproj.io/v1alpha1
        kind: Application
        metadata:
          name: "${each.key}"
          namespace: argocd
          finalizers: []
          annotations: {}
        spec:
          project: "${each.value.project}"
          source:
            repoURL: "${each.value.repo}"
            path: "${each.value.path}"
            targetRevision: "${each.value.branch}"
            directory:
              recurse: ${each.value.recurse}
              jsonnet: {}
${lookup(each.value, "include", null) != null ? "              include: \"${each.value.include}\"\n" : ""}${lookup(each.value, "exclude", null) != null ? "              exclude: \"${each.value.exclude}\"\n" : ""}
          destination:
            server: 'https://kubernetes.default.svc'
            namespace: ${kubernetes_namespace_v1.infra["argocd"].metadata[0].name}
          syncPolicy:
            automated:
              prune: true
              allowEmpty: true
              selfHeal: true
          ignoreDifferences:
            - group: '*'
              kind: '*'
              jsonPointers:
                - /metadata/finalizers
    EOF
  ]
  depends_on = [
    helm_release.argocd
  ]
}

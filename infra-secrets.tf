# # Resources in this .tf file should only trigger if var.doppler_token is populated

resource "helm_release" "external_secrets_operator" {
  count         = var.doppler_token != "" ? 1 : 0
  name          = "external-secrets"
  namespace     = kubernetes_namespace_v1.infra["external-secrets"].metadata[0].name
  repository    = "https://charts.external-secrets.io"
  chart         = "external-secrets"
  version       = "0.9.7"
  verify        = false
  force_update  = true
  recreate_pods = true
}

resource "kubernetes_secret_v1" "doppler_secret_inl" {
  count = var.doppler_token != "" ? 1 : 0
  metadata {
    name      = "doppler-token-inl"
    namespace = kubernetes_namespace_v1.infra["external-secrets"].metadata[0].name
  }
  data = {
    serviceToken = var.doppler_token
  }
  depends_on = [
    helm_release.external_secrets_operator
  ]
}

resource "helm_release" "external_managed_secret_stores" {
  count      = var.doppler_token != "" ? 1 : 0
  name       = "external-managed-secret-stores"
  namespace  = kubernetes_namespace_v1.infra["external-secrets"].metadata[0].name
  repository = "https://bedag.github.io/helm-charts/"
  chart      = "raw"
  version    = "2.0.0"
  values = [<<-EOF
    resources:
      - apiVersion: external-secrets.io/v1beta1
        kind: ClusterSecretStore
        metadata:
          name: doppler-inl
          namespace: ${helm_release.external_secrets_operator[0].namespace}
        spec:
          provider:
            doppler:
              auth:
                secretRef:
                  dopplerToken:
                    name: ${kubernetes_secret_v1.doppler_secret_inl[0].metadata[0].name}
                    namespace: ${kubernetes_secret_v1.doppler_secret_inl[0].metadata[0].namespace}
                    key: serviceToken
      - apiVersion: external-secrets.io/v1beta1
        kind: ClusterExternalSecret
        metadata:
          name: doppler-inl
        spec:
          namespaceSelector:
            matchLabels:
              external-secrets-inl: please
          refreshTime: 2m
          externalSecretSpec:
            refreshInterval: 2m
            secretStoreRef:
              kind: ClusterSecretStore
              name: doppler-inl
            target:
              name: doppler-secret
              creationPolicy: Owner
            dataFrom:
              - find:
                  name:
                    regexp: .*
                rewrite: []
    EOF
  ]
  depends_on = [
    helm_release.external_secrets_operator
  ]
}

resource "time_sleep" "populate_external_managed_secret_stores" {
  create_duration = "30s"
  depends_on      = [helm_release.external_managed_secret_stores]
}

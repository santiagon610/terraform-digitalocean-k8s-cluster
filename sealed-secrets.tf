resource "kubernetes_secret_v1" "sealed_secrets" {
  count = length(var.sealed_secrets_privatekey) > 0 ? 1 : 0
  metadata {
    name      = "sealed-secrets-key"
    namespace = "kube-system"
    labels = {
      "sealedsecrets.bitnami.com/sealed-secrets-key" = "active"
    }
  }

  data = {
    "tls.crt" = var.sealed_secrets_certificate
    "tls.key" = var.sealed_secrets_privatekey
  }

  type = "kubernetes.io/tls"
}

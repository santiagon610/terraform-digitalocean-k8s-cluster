data "kubernetes_secret_v1" "argo_doppler" {
  metadata {
    name      = "doppler-secret"
    namespace = kubernetes_namespace_v1.infra["argocd"].metadata[0].name
  }
  depends_on = [
    helm_release.external_secrets_operator,
    helm_release.external_managed_secret_stores,
    time_sleep.populate_external_managed_secret_stores
  ]
}

locals {
  argocd_config = {
    fqdn = var.argo_fqdn
    oauth = {
      name          = "Jumpcloud"
      issuer        = "https://oauth.id.jumpcloud.com/"
      client_id     = data.kubernetes_secret_v1.argo_doppler.data.ARGOCD_OIDC_CLIENTID
      client_secret = data.kubernetes_secret_v1.argo_doppler.data.ARGOCD_OIDC_CLIENTSECRET
    }
    repos = {
      argo_apps = {
        app_name              = "argo-apps-primary"
        url                   = "https://git.coreinfra.cloud/coreinfra/argo-apps.git"
        type                  = "git"
        branch                = "main"
        recurse               = true
        sync_prune            = true
        sync_selfheal         = true
        path                  = "/"
        username              = "argocd-deployer"
        password              = data.kubernetes_secret_v1.argo_doppler.data.GITLABCOREINFRAACCESSKEY
        project               = "default"
        destination_namespace = "argocd"
      }
    }
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = kubernetes_namespace_v1.infra["argocd"].metadata[0].name
  chart      = "argo-cd"
  version    = "6.7.11"
  values = [<<-EOF
  server:
    replicas: 1
    ingress:
      enabled: true
      annotations:
        cert-manager.io/cluster-issuer: "letsencrypt-prod"
        nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
        nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      ingressClassName: "nginx"
      https: false
      hostname: ${local.argocd_config.fqdn}
      tls:
        - secretName: argocd-tls
          hosts:
            - ${local.argocd_config.fqdn}
    rbacConfig:
      policy.csv: |
        p, role:clusterAdmin, *, *, *, allow
        p, role:noPerms, *, *, *, deny
        g, JC_ARGOCD_ADMIN, role:clusterAdmin
        g, JC_ARGOCD_RO, role:readonly
    resources:
      limits:
        cpu: 100m
        memory: 128Mi
      requests:
        cpu: 50m
        memory: 64Mi
  controller:
    resources:
      limits:
        cpu: 500m
        memory: 512Mi
      requests:
        cpu: 250m
        memory: 256Mi
  repoServer:
    replicas: 2
    resources:
      limits:
        cpu: 500m
        memory: 512Mi
      requests:
        cpu: 250m
        memory: 256Mi
  global:
    logging:
      format: json
      level: warn
  configs:
    params:
      create: true
      server.insecure: true
      oidc.tls.insecure.skip.verify: true
    cm:
      create: true
      url: "https://${local.argocd_config.fqdn}/"
      admin.enabled: false
      exec.enabled: true
      oidc.config: |
          name: ${local.argocd_config.oauth.name}
          issuer: "${local.argocd_config.oauth.issuer}"
          clientID: "${local.argocd_config.oauth.client_id}"
          clientSecret: "${local.argocd_config.oauth.client_secret}"
          requestedScopes:
            - openid
            - email
            - profile
            - groups
      ui.bannercontent: "${var.argo_banner}"
      ui.bannerpermanent: true
      ui.bannerposition: "top"
      statusbadge.enabled: true
    rbac:
      create: true
      scopes: "[groups]"
    repositories:
      argo-apps:
        url: ${local.argocd_config.repos.argo_apps.url}
        type: ${local.argocd_config.repos.argo_apps.type}
        username: ${local.argocd_config.repos.argo_apps.username}
        password: "${local.argocd_config.repos.argo_apps.password}"
EOF
  ]
}

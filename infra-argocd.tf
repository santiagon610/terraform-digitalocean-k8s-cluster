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
    fqdn = var.argocd_fqdn
    oauth = {
      name                       = var.argocd_oidc_issuer_name
      issuer                     = var.argocd_oidc_issuer_url
      client_id                  = var.argocd_oidc_client_id
      client_secret              = var.argocd_oidc_client_secret
      admin_gg                   = var.argocd_oidc_admin_group
      readonly_gg                = var.argocd_oidc_readonly_group
      enable_pkce_authentication = length(var.argocd_oidc_client_secret) > 0 ? false : true
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
  version    = "7.7.18"
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
          enablePKCEAuthentication: ${local.argocd_config.oauth.enable_pkce_authentication}
          requestedScopes:
            - openid
            - email
            - profile
            - groups
      ui.bannercontent: "${var.argocd_banner}"
      ui.bannerpermanent: true
      ui.bannerposition: "top"
      statusbadge.enabled: true
      statusbadge.url: "https://${local.argocd_config.fqdn}/"
    rbac:
      create: true
      scopes: "[groups]"
      policy.csv: |
        p, role:clusterAdmin, *, *, *, allow
        p, role:noPerms, *, *, *, deny
        g, ${local.argocd_config.oauth.admin_gg}, role:clusterAdmin
        g, ${local.argocd_config.oauth.readonly_gg}, role:readonly
    repositories:
      argo-apps:
        url: ${local.argocd_config.repos.argo_apps.url}
        type: ${local.argocd_config.repos.argo_apps.type}
        username: ${local.argocd_config.repos.argo_apps.username}
        password: "${local.argocd_config.repos.argo_apps.password}"
  notifications:
    enabled: true
    secret:
      create: false
    cm:
      create: false
EOF
  ]
}

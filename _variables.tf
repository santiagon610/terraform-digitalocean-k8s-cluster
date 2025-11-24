variable "doppler_token" {
  description = "Service token to access Doppler"
  type        = string
  default     = ""
}

variable "argocd_helm_repo" {
  description = "URL to Helm chart"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argocd_helm_chart" {
  description = "Name of Helm chart"
  type        = string
  default     = "argo-cd"
}

variable "argocd_helm_version" {
  description = "Version of the `var.argocd_helm_chart` to use"
  type        = string
  default     = "9.1.4"
}

variable "argocd_repo" {
  description = "Git repo for Argo apps"
  type        = string
  default     = "https://git.coreinfra.cloud/coreinfra/argo-apps.git"
}

variable "argocd_branch" {
  description = "Git branch for Argo apps"
  type        = string
  default     = "main"
}

variable "argocd_path" {
  description = "Path in `var.argocd_repo` in which app defs are placed"
  type        = string
  default     = "."
}

variable "argocd_path_recursive" {
  description = "Should ArgoCD recurse through `var.argocd_path`?"
  type        = bool
  default     = true
}

variable "app_projects" {
  description = "List of app namespace and Argo projects"
  type        = list(string)
  default     = []
}

variable "app_projects_v2" {
  description = "List of app namespace and Argo projects - v2"
  type        = map(any)
  default     = {}
}

variable "slack_token" {
  description = "Slack token for notifications"
  type        = string
  default     = ""
}

variable "slack_displayname" {
  description = "Display name for Slack notifications"
  type        = string
  default     = "Terraform"
}

variable "argocd_fqdn" {
  description = "FQDN to access ArgoCD"
  type        = string
  default     = "argocd.example.com"
}

variable "argocd_banner" {
  description = "ArgoCD top banner"
  type        = string
  default     = ""
}

variable "argocd_environments" {
  description = "Map of ArgoCD environments"
  type        = map(any)
  default = {
    dev = {
      repo    = "https://github.com/example/repo.git"
      path    = "path/to/app"
      branch  = "main"
      recurse = true
      project = "default"
    }
  }
}

variable "infra_namespaces" {
  description = "List of namespaces to create"
  type        = list(string)
  default = [
    "argocd",
    "external-secrets",
    "inl-infra"
  ]
}

variable "sealed_secrets_certificate" {
  description = "Certificate for Sealed Secrets"
  type        = string
  default     = ""
}

variable "sealed_secrets_privatekey" {
  description = "Private key for Sealed Secrets"
  type        = string
  default     = ""
}

variable "argocd_oidc_client_id" {
  description = "OIDC client ID for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_oidc_client_secret" {
  description = "OIDC client secret for ArgoCD"
  type        = string
  default     = ""
}

variable "argocd_oidc_issuer_name" {
  description = "OIDC issuer name for ArgoCD"
  type        = string
  default     = "SSO"
}

variable "argocd_oidc_issuer_url" {
  description = "OIDC issuer URL for ArgoCD"
  type        = string
  default     = "https://sso.example.com/auth/realms/master"
}

variable "argocd_oidc_admin_group" {
  description = "OIDC admin group for ArgoCD"
  type        = string
  default     = "argocd-admins"
}

variable "argocd_oidc_readonly_group" {
  description = "OIDC readonly group for ArgoCD"
  type        = string
  default     = "argocd-readonly"
}

variable "ingress_class" {
  description = "Ingress class to use"
  type        = string
  default     = "nginx"
}

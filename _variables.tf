variable "doppler_token" {
  description = "Service token to access Doppler"
  type        = string
  default     = ""
}

variable "argo_repo" {
  description = "Git repo for Argo apps"
  type        = string
  default     = "https://git.coreinfra.cloud/coreinfra/argo-apps.git"
}

variable "argo_branch" {
  description = "Git branch for Argo apps"
  type        = string
  default     = "main"
}

variable "argo_path" {
  description = "Path in argo_repo in which app defs are placed"
  type        = string
  default     = "."
}

variable "argo_path_recursive" {
  description = "Should ArgoCD recurse through argo_path?"
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

variable "argo_fqdn" {
  description = "FQDN to access ArgoCD"
  type        = string
  default     = "argocd.example.com"
}

variable "argo_banner" {
  description = "ArgoCD top banner"
  type        = string
  default     = ""
}

variable "argo_environments" {
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

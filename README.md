<!-- BEGIN_TF_DOCS -->
# Kubernetes Bootstrap

Adds the normal INL accoutrement to a bare Kubernetes cluster.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.app_argocd_project](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.app_argocd_project_v2](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.argocd_apps_env](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_managed_secret_stores](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_secrets_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.infra_argo_project](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.app](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.app_v2](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.infra](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.doppler_secret_inl](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.sealed_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [time_sleep.populate_external_managed_secret_stores](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [kubernetes_secret_v1.argo_doppler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_projects"></a> [app\_projects](#input\_app\_projects) | List of app namespace and Argo projects | `list(string)` | `[]` | no |
| <a name="input_app_projects_v2"></a> [app\_projects\_v2](#input\_app\_projects\_v2) | List of app namespace and Argo projects - v2 | `map(any)` | `{}` | no |
| <a name="input_argocd_banner"></a> [argocd\_banner](#input\_argocd\_banner) | ArgoCD top banner | `string` | `""` | no |
| <a name="input_argocd_branch"></a> [argocd\_branch](#input\_argocd\_branch) | Git branch for Argo apps | `string` | `"main"` | no |
| <a name="input_argocd_environments"></a> [argocd\_environments](#input\_argocd\_environments) | Map of ArgoCD environments | `map(any)` | <pre>{<br/>  "dev": {<br/>    "branch": "main",<br/>    "path": "path/to/app",<br/>    "project": "default",<br/>    "recurse": true,<br/>    "repo": "https://github.com/example/repo.git"<br/>  }<br/>}</pre> | no |
| <a name="input_argocd_fqdn"></a> [argocd\_fqdn](#input\_argocd\_fqdn) | FQDN to access ArgoCD | `string` | `"argocd.example.com"` | no |
| <a name="input_argocd_helm_chart"></a> [argocd\_helm\_chart](#input\_argocd\_helm\_chart) | Name of Helm chart | `string` | `"argo-cd"` | no |
| <a name="input_argocd_helm_repo"></a> [argocd\_helm\_repo](#input\_argocd\_helm\_repo) | URL to Helm chart | `string` | `"https://argoproj.github.io/argo-helm"` | no |
| <a name="input_argocd_helm_version"></a> [argocd\_helm\_version](#input\_argocd\_helm\_version) | Version of the `var.argocd_helm_chart` to use | `string` | `"8.1.1"` | no |
| <a name="input_argocd_oidc_admin_group"></a> [argocd\_oidc\_admin\_group](#input\_argocd\_oidc\_admin\_group) | OIDC admin group for ArgoCD | `string` | `"argocd-admins"` | no |
| <a name="input_argocd_oidc_client_id"></a> [argocd\_oidc\_client\_id](#input\_argocd\_oidc\_client\_id) | OIDC client ID for ArgoCD | `string` | `"argocd"` | no |
| <a name="input_argocd_oidc_client_secret"></a> [argocd\_oidc\_client\_secret](#input\_argocd\_oidc\_client\_secret) | OIDC client secret for ArgoCD | `string` | `""` | no |
| <a name="input_argocd_oidc_issuer_name"></a> [argocd\_oidc\_issuer\_name](#input\_argocd\_oidc\_issuer\_name) | OIDC issuer name for ArgoCD | `string` | `"SSO"` | no |
| <a name="input_argocd_oidc_issuer_url"></a> [argocd\_oidc\_issuer\_url](#input\_argocd\_oidc\_issuer\_url) | OIDC issuer URL for ArgoCD | `string` | `"https://sso.example.com/auth/realms/master"` | no |
| <a name="input_argocd_oidc_readonly_group"></a> [argocd\_oidc\_readonly\_group](#input\_argocd\_oidc\_readonly\_group) | OIDC readonly group for ArgoCD | `string` | `"argocd-readonly"` | no |
| <a name="input_argocd_path"></a> [argocd\_path](#input\_argocd\_path) | Path in `var.argocd_repo` in which app defs are placed | `string` | `"."` | no |
| <a name="input_argocd_path_recursive"></a> [argocd\_path\_recursive](#input\_argocd\_path\_recursive) | Should ArgoCD recurse through `var.argocd_path`? | `bool` | `true` | no |
| <a name="input_argocd_repo"></a> [argocd\_repo](#input\_argocd\_repo) | Git repo for Argo apps | `string` | `"https://git.coreinfra.cloud/coreinfra/argo-apps.git"` | no |
| <a name="input_doppler_token"></a> [doppler\_token](#input\_doppler\_token) | Service token to access Doppler | `string` | `""` | no |
| <a name="input_infra_namespaces"></a> [infra\_namespaces](#input\_infra\_namespaces) | List of namespaces to create | `list(string)` | <pre>[<br/>  "argocd",<br/>  "external-secrets",<br/>  "inl-infra"<br/>]</pre> | no |
| <a name="input_ingress_class"></a> [ingress\_class](#input\_ingress\_class) | Ingress class to use | `string` | `"nginx"` | no |
| <a name="input_sealed_secrets_certificate"></a> [sealed\_secrets\_certificate](#input\_sealed\_secrets\_certificate) | Certificate for Sealed Secrets | `string` | `""` | no |
| <a name="input_sealed_secrets_privatekey"></a> [sealed\_secrets\_privatekey](#input\_sealed\_secrets\_privatekey) | Private key for Sealed Secrets | `string` | `""` | no |
| <a name="input_slack_displayname"></a> [slack\_displayname](#input\_slack\_displayname) | Display name for Slack notifications | `string` | `"Terraform"` | no |
| <a name="input_slack_token"></a> [slack\_token](#input\_slack\_token) | Slack token for notifications | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
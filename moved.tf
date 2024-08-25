moved {
  from = helm_release.app_argo_project
  to   = helm_release.app_argocd_project
}

moved {
  from = helm_release.app_argo_project_v2
  to   = helm_release.app_argocd_project_v2
}

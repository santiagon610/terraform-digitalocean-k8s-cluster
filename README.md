# DigitalOcean Kubernetes Cluster

Want a Kubernetes cluster with some straightforward guardrails? Well, here it is.

## Features

- Kubernetes Cluster
- Initial Node Pool
- Toggle for 

## Terraform versions

I've tested this on 1.4.4 onward, and seems to be fine. If you find an issue, feel free to raise an issue.

### Example Usage

```hcl
module "k8s_prod" {
  source = "git::https://git.coreinfra.cloud/coreinfra/tf-modules/do-k8s-cluster?ref=v1.0.0"

  cluster_name           = "my_k8s_cluster"
  region                 = "nyc1"
  vpc_uuid               = data.digitalocean_region.current.id
  version                = data.digitalocean_k8s_versions.latest_version
  auto_upgrade           = true
  nodepool01_min         = 1
  nodepool01_max         = 2
  nodepool01_dropletsize = "s-4vcpu-8gb"
  enable_nodepool02      = true
  nodepool02_min         = 1
  nodepool02_max         = 2
  nodepool02_dropletsize = "s-4vcpu-8gb"
}
```

## Providers

- [DigitalOcean](https://registry.terraform.io/providers/digitalocean/digitalocean)

## Outputs

- `kubeconfig`: Output as a map, rendered in two formats.
  - `hcl`: For ingestion by other Terraform providers, like Kubernetes or Helm
  - `yaml`: For ingestion by your secrets manager, local system for Kubeconfig, or the like

## Authors

- [Nicholas Santiago](https://github.com/santiagon610)

## License

Internal

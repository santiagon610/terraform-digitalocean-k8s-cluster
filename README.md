<!-- BEGIN_TF_DOCS -->
# Kubernetes Cluster

Builds a DigitalOcean Kubernetes cluster in a way that makes more sense to
me, and is more easily wrapped in a manner to keep the Terraform code DRY.

## Usage

```hcl
module "cluster" {
  source                = "santiagon610/k8s-cluster/digitalocean"
  version               = "~> 2"
  cluster_name          = "my-awesome-cluster"
  region                = "nyc1"
  vpc_uuid              = data.digitalocean_vpc.production.id
  cluster_tags          = ["production"]
  initial_node_pool = {
    name       = "primary"
    size       = "s-4vcpu-8gb"
    min_nodes  = 1
    max_nodes  = 4
    auto_scale = true
    labels = {
      pizza       = "pepperoni"
      environment = "prod"
     }
  }
  maintenance_policy = {
    start_time = "22:00"
    day        = "monday"
  }
}
```

## Caveats

- If `var.k8s_version` is defined and not blank, the module will treat the
  version of Kubernetes as pinned and will disable automatic upgrades, and
  as a result will remove the maintenance policy. Although this does not
  make make the `var.k8s_version` input mutually exclusive with
  `var.maintenance_policy`, they do render one another essentially inert.

## Authentication

Set the `DIGITALOCEAN_TOKEN` environment variable to your DigitalOcean API
token.

## License

[CC0 1.0 Universal](LICENSE)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_kubernetes_cluster.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_cluster) | resource |
| [digitalocean_kubernetes_node_pool.additional](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_node_pool) | resource |
| [digitalocean_kubernetes_versions.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/kubernetes_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_node_pools"></a> [additional\_node\_pools](#input\_additional\_node\_pools) | Configuration for additional node pools | <pre>map(object({<br>    min_nodes  = number<br>    max_nodes  = number<br>    size       = string<br>    auto_scale = bool<br>    labels     = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Display name of Kubernetes cluster | `string` | n/a | yes |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | Tags to apply to Kubernetes cluster within DigitalOcean console | `list(string)` | `[]` | no |
| <a name="input_do_registry_integration"></a> [do\_registry\_integration](#input\_do\_registry\_integration) | Enable integration with DigitalOcean Container Registry | `bool` | `true` | no |
| <a name="input_initial_node_pool"></a> [initial\_node\_pool](#input\_initial\_node\_pool) | Configuration for initial node pool | <pre>object({<br>    name       = string<br>    min_nodes  = number<br>    max_nodes  = number<br>    size       = string<br>    auto_scale = bool<br>    labels     = map(string)<br>  })</pre> | <pre>{<br>  "auto_scale": true,<br>  "labels": {<br>    "droplet-size": "s-4vcpu-8gb",<br>    "managed-by": "terraform",<br>    "purpose": "default"<br>  },<br>  "max_nodes": 2,<br>  "min_nodes": 1,<br>  "name": "initial",<br>  "size": "s-4vcpu-8gb"<br>}</pre> | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of k8s control plane to use. If blank, uses `data.digitalocean_kubernetes_versions.this.latest_version` | `string` | `""` | no |
| <a name="input_maintenance_policy"></a> [maintenance\_policy](#input\_maintenance\_policy) | Maintenance policy for Kubernetes control plane. Ignored if `var.k8s_version` is defined. | <pre>object({<br>    start_time = string<br>    day        = string<br>  })</pre> | <pre>{<br>  "day": "sunday",<br>  "start_time": "04:00"<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | DigitalOcean region in which to build Kubernetes cluster | `string` | `"nyc1"` | no |
| <a name="input_vpc_uuid"></a> [vpc\_uuid](#input\_vpc\_uuid) | UUID of the VPC network in which to build Kubernetes cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Kubernetes configuration for the cluster, provided in HCL and YAML. |
<!-- END_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
# Kubernetes Cluster

Builds a DigitalOcean Kubernetes cluster in a way that
makes sense to me.

Author: [Nicholas Santiago](https://github.com/santiagon610/)

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
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Descriptive name of k8s cluster | `string` | `"k8s"` | no |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | Tags to apply to k8s cluster within DigitalOcean console | `list(string)` | `[]` | no |
| <a name="input_do_registry_integration"></a> [do\_registry\_integration](#input\_do\_registry\_integration) | Integrate cluster with DO registry? | `bool` | `true` | no |
| <a name="input_initial_node_pool"></a> [initial\_node\_pool](#input\_initial\_node\_pool) | Configuration for initial node pool | <pre>object({<br>    name       = string<br>    min_nodes  = number<br>    max_nodes  = number<br>    size       = string<br>    auto_scale = bool<br>    labels     = map(string)<br>  })</pre> | <pre>{<br>  "auto_scale": true,<br>  "labels": {<br>    "droplet-size": "s-4vcpu-8gb",<br>    "managed-by": "terraform",<br>    "purpose": "default"<br>  },<br>  "max_nodes": 2,<br>  "min_nodes": 1,<br>  "name": "initial",<br>  "size": "s-4vcpu-8gb"<br>}</pre> | no |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | Version of k8s control plane to use. If blank, uses `data.digitalocean_kubernetes_versions.this.latest_version` | `string` | `""` | no |
| <a name="input_maintenance_policy"></a> [maintenance\_policy](#input\_maintenance\_policy) | Maintenance policy for k8s control plane | <pre>object({<br>    start_time = string<br>    day        = string<br>  })</pre> | <pre>{<br>  "day": "sunday",<br>  "start_time": "04:00:00"<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | Digital Ocean region in which to build cluster | `string` | `"nyc1"` | no |
| <a name="input_vpc_uuid"></a> [vpc\_uuid](#input\_vpc\_uuid) | VPC UUID in which to build cluster | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Kubernetes configuration for the cluster, provided in HCL and YAML. |
<!-- END_TF_DOCS -->
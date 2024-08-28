/**
 * # Kubernetes Cluster
 *
 * Builds a DigitalOcean Kubernetes cluster in a way that makes more sense to
 * me, and is more easily wrapped in a manner to keep the Terraform code DRY.
 *
 * ## Usage
 *
 * ```hcl
 * module "cluster" {
 *   source                = "santiagon610/k8s-cluster/digitalocean"
 *   version               = "~> 2"
 *   cluster_name          = "my-awesome-cluster"
 *   region                = "nyc1"
 *   vpc_uuid              = data.digitalocean_vpc.production.id
 *   cluster_tags          = ["production"]
 *   initial_node_pool = {
 *     name       = "primary"
 *     size       = "s-4vcpu-8gb"
 *     min_nodes  = 1
 *     max_nodes  = 4
 *     auto_scale = true
 *     labels = {
 *       pizza       = "pepperoni"
 *       environment = "prod"
 *      }
 *   }
 *   maintenance_policy = {
 *     start_time = "22:00"
 *     day        = "monday"
 *   }
 * }
 * ```
 *
 * ## Caveats
 * 
 * - If `var.k8s_version` is defined and not blank, the module will treat the
 *   version of Kubernetes as pinned and will disable automatic upgrades, and
 *   as a result will remove the maintenance policy. Although this does not 
 *   make make the `var.k8s_version` input mutually exclusive with 
 *   `var.maintenance_policy`, they do render one another essentially inert.
 * 
 * ## Authentication
 *
 * Set the `DIGITALOCEAN_TOKEN` environment variable to your DigitalOcean API
 * token.
 *
 * ## License
 * 
 * [CC0 1.0 Universal](LICENSE)
 */

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

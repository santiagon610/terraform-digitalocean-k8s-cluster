/**
 * # Kubernetes Cluster
 *
 * Builds a DigitalOcean Kubernetes cluster in a way that
 * makes sense to me.
 *
 * Author: [Nicholas Santiago](https://github.com/santiagon610/)
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

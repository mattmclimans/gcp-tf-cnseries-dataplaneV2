# ----------------------------------------------------------------------------
#  variables - main.tf
variable "project_id" {
  description = "The GCP project ID"
  default     = null
}

variable "region" {
  description = "The GCP region"
  default     = "us-east1"
}

variable "prefix" {
  description = "Prefix to add before resource names"
  #default     = "mrm"
}

# ----------------------------------------------------------------------------
# variables - cluster.tf
variable "k8s_version" {
  description = "The version of Kubernetes"
  default     = "1.23.6-gke.1500" // Pull version: gcloud container get-server-config --zone=us-east1-a --format=json
}

variable "k8s_enable_dpv2" {
  description = "Boolean operator to enable or disable Dataplane V2. True is enabled."
  default     = true
}

variable "subnet_cidr" {
  description = "Subnet CIDR range"
  default     = "10.0.0.0/16"
}

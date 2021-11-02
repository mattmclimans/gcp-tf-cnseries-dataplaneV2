# ----------------------------------------------------------------------------
#  variables - main.tf
variable "project" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region"
}

# ----------------------------------------------------------------------------
# variables - cluster.tf
variable "k8s_version" {
  default     = "1.20.9-gke.1001" # "1.17"
  type        = string
  description = "The version of Kubernetes"
}

variable "k8s_enable_dpv2" {
  default = false
}

variable "subnet_cidr" {
  description = "Subnetwork CIDR range to be created"
}

# ----------------------------------------------------------------------------
# variables - cnseries.tf
variable "panorama_ip" {
  description = "The primary Panorama IP address"
  type        = string
}

variable "panorama_ip2" {
  default     = ""
  description = "The secondary Panorama IP address"
  type        = string
}

variable "panorama_auth_key" {
  description = "The Panorama auth key for VM-series registration"
  type        = string
}

variable "panorama_device_group" {
  description = "The Panorama device group"
  type        = string
}

variable "panorama_template_stack" {
  description = "The Panorama template stack"
  type        = string
}

variable "panorama_collector_group" {
  description = "The Panorama log collector group"
  type        = string
}

variable "k8s_cni_image" {
  default     = "docker.io/paloaltonetworks/pan_cni"
  description = "The CNI container image"
  type        = string
}

variable "k8s_cni_version" {
  default     = "latest"
  description = "The CNI container image version tag"
  type        = string
}

variable "k8s_mp_init_image" {
  default     = "docker.io/paloaltonetworks/pan_cn_mgmt_init"
  description = "The MP init container image"
  type        = string
}

variable "k8s_mp_init_version" {
  default     = "latest"
  description = "The MP init container image version tag"
  type        = string
}

variable "k8s_mp_image" {
  default     = "docker.io/paloaltonetworks/panos_cn_mgmt"
  description = "The MP container image"
  type        = string
}

variable "k8s_mp_image_version" {
  default     = "latest"
  description = "The MP container image version tag"
  type        = string
}

variable "k8s_mp_cpu" {
  default     = "2"
  description = "The MP container CPU limit"
  type        = string
}


variable "k8s_dp_image" {
  default     = "docker.io/paloaltonetworks/panos_cn_ngfw"
  description = "The DP container image"
  type        = string
}

variable "k8s_dp_image_version" {
  default     = "latest"
  description = "The DP container image version tag"
  type        = string
}

variable "k8s_dp_cpu" {
  default     = "1"
  description = "The DP container CPU limit"
  type        = string
}

variable "csp_pin_id" {
  default = "2aea51ae-e147-4933-81b4-e6695e9a5d86"
}

variable "csp_pin_value" {
  default = "493fd484d6e74434b54b06c1249cb614"
}

variable "helm_repo" {
  description = "Helm repo that contains CN-Series helm charts."
}

variable "helm_version" {
  description = "Helm repo chart version"
}

terraform {}

provider "google" {
  #project = var.project
  region = var.region
}

resource "random_pet" "main" {
  length = 1
}

locals {
  prefix = random_pet.main.id
}

# -------------------------------------------------------------------------------
# Create VPC network
resource "google_compute_network" "cluster" {
  name = "${local.prefix}-vpc"
}

resource "google_compute_subnetwork" "cluster" {
  name          = "${google_compute_network.cluster.name}-subnet-${var.region}"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.cluster.id
}

resource "google_compute_firewall" "rules" {
  name          = "${google_compute_network.cluster.name}-01"
  network       = google_compute_network.cluster.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
    ports    = []
  }
}

# -------------------------------------------------------------------------------
# Create cluster
resource "google_container_cluster" "cluster" {
  name               = "${local.prefix}-k8s"
  location           = var.region
  min_master_version = var.k8s_version

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_subnetwork.cluster.network
  subnetwork = google_compute_subnetwork.cluster.self_link

  network_policy {
    # Enabling NetworkPolicy for clusters with DatapathProvider=ADVANCED_DATAPATH is not allowed (yields error)
    enabled = var.k8s_enable_dpv2 ? false : true
    # CALICO provider overrides datapath_provider setting, leaving Dataplane v2 disabled
    provider = var.k8s_enable_dpv2 ? "PROVIDER_UNSPECIFIED" : "CALICO"
  }
  # This is where Dataplane V2 is enabled.
  datapath_provider = var.k8s_enable_dpv2 ? "ADVANCED_DATAPATH" : "DATAPATH_PROVIDER_UNSPECIFIED"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  depends_on = []
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = "${local.prefix}-nodepool"
  location = var.region
  cluster  = google_container_cluster.cluster.name

  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n2-standard-8"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# -------------------------------------------------------------------------------
# Create CN-Series
data "google_client_config" "main" {}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"

    token                  = data.google_client_config.main.access_token
    host                   = google_container_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)

  }
}

resource "helm_release" "cn-series" {
  name       = "cn-series-deploy"
  repository = var.helm_repo
  chart      = "cn-series"
  version    = var.helm_version
  timeout    = 600
  wait       = false

  set {
    name  = "cluster.deployTo"
    value = "gke"
    type  = "string"
  }

  set {
    name  = "panorama.ip"
    value = var.panorama_ip
    type  = "string"
  }

  set {
    name  = "panorama.ip2"
    value = var.panorama_ip2
    type  = "string"
  }

  set {
    name  = "panorama.authKey"
    value = var.panorama_auth_key
    type  = "string"
  }

  set {
    name  = "panorama.deviceGroup"
    value = var.panorama_device_group
    type  = "string"
  }

  set {
    name  = "panorama.template"
    value = var.panorama_template_stack
    type  = "string"
  }

  set {
    name  = "panorama.cgName"
    value = var.panorama_collector_group
    type  = "string"
  }

  // CSP values
  set {
    name  = "csp.pinId"
    value = var.csp_pin_id
    type  = "string"
  }
  set {
    name  = "csp.pinValue"
    value = var.csp_pin_value
    type  = "string"
  }

  set {
    name  = "cni.image"
    value = var.k8s_cni_image
    type  = "string"
  }

  set {
    name  = "cni.version"
    value = var.k8s_cni_version
    type  = "string"
  }

  set {
    name  = "mp.initImage"
    value = var.k8s_mp_init_image
    type  = "string"
  }

  set {
    name  = "mp.initVersion"
    value = var.k8s_mp_init_version
    type  = "string"
  }

  set {
    name  = "mp.image"
    value = var.k8s_mp_image
    type  = "string"
  }

  set {
    name  = "mp.version"
    value = var.k8s_mp_image_version
    type  = "string"
  }

  set {
    name  = "mp.cpuLimit"
    value = var.k8s_mp_cpu
  }

  set {
    name  = "dp.image"
    value = var.k8s_dp_image
    type  = "string"
  }

  set {
    name  = "dp.version"
    value = var.k8s_dp_image_version
    type  = "string"
  }

  set {
    name  = "dp.cpuLimit"
    value = var.k8s_dp_cpu
    type  = "string"
  }

  set {
    name  = "firewall.failoverMode"
    value = "failclose"
    type  = "string"
  }

  set {
    name  = "firewall.operationMode"
    value = "daemonset"
    type  = "string"
  }

  set {
    name  = "firewall.serviceName"
    value = "pan-mgmt-svc"
    type  = "string"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
    type  = "string"
  }
}


# -------------------------------------------------------------------------------
# Configure cluster authentication and download Panorama plugin service account
resource "null_resource" "configure_cluster" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.cluster.name} --region ${google_container_cluster.cluster.location} --project ${google_container_cluster.cluster.project}"
  }

  depends_on = [
    helm_release.cn-series
  ]
}

resource "null_resource" "grab_plugin_credentials" {
  provisioner "local-exec" {
    command = "chmod +x scripts/fetch_plugin_creds.sh && ./scripts/fetch_plugin_creds.sh"
  }

  depends_on = [
    null_resource.configure_cluster
  ]
}

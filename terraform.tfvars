#project                  = ""                               # Your GCP project ID
panorama_ip              = "<your_panorama_ip>"             # Panorama IP address
panorama_auth_key        = "<your_panorama_vm_auth_key>"    # Panorama authkey for CN-Series connection
k8s_enable_dpv2          = true
k8s_version              = "1.21.3-gke.2001"

# ---------------------------------------------------
region                   = "us-west1"                       
subnet_cidr              = "10.0.0.0/24"

panorama_device_group    = "gcp-gke"         # Panorama device group
panorama_template_stack  = "gcp-gke_stack"   # Panorama template stack
panorama_collector_group = "collector-group" # Panorama log collector group
panorama_ip2             = ""

k8s_mp_init_image        = "us.gcr.io/panw-gcp-team-testing/paloaltonetworks/pan_cn_mgmt_init"
k8s_mp_init_version      = "2.0.0"
k8s_mp_image             = "us.gcr.io/panw-gcp-team-testing/paloaltonetworks/panos_cn_mgmt"
k8s_mp_image_version     = "10.1.2"
k8s_mp_cpu               = 2
k8s_dp_image             = "us.gcr.io/panw-gcp-team-testing/paloaltonetworks/panos_cn_ngfw"
k8s_dp_image_version     = "10.1.2"
k8s_dp_cpu               = 1
k8s_cni_image            = "us.gcr.io/panw-gcp-team-testing/paloaltonetworks/pan_cni"
k8s_cni_version          = "2.0.1"

helm_repo                = "https://mattmclimans.github.io/cn-series-helm/"
helm_version             = "1.0.3" // CN-Series as daemon PAN-OS 10.1.x
#helm_version             = "0.1.8" // CN-Series as service PAN-OS 10.1.x

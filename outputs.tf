output "API_SERVER_ADDRESS" {
  description = "The IP endpoint of the GKE cluster master.  Use this value in the Kubernetes Panorama plugin for the API Server Address"
  value = google_container_cluster.cluster.endpoint
}

output "cluster_name" {
  value = ${google_container_cluster.cluster.name}
}
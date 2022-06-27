#/bin/bash
# Authenticate with:
# gcloud container clusters get-credentials mrm-dpv2-cluster --region us-east4 --project panw-gcp-team-testing

kubectl apply -f pan-mgmt-serviceaccount.yaml
kubectl apply -f pan-cni-serviceaccount.yaml
kubectl get serviceaccounts -n kube-system
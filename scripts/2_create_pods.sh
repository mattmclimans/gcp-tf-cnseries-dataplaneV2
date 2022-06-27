# Deploy CNI DaemonSet
# ----------------------------------------------------------------
kubectl apply -f pan-cni-configmap.yaml
kubectl apply -f pan-cn-ngfw-svc.yaml
sleep 2
kubectl apply -f pan-cni.yaml
sleep 2
kubectl apply -f pan-cn-mgmt-configmap.yaml
kubectl apply -f pan-cn-mgmt-slot-crd.yaml
kubectl apply -f pan-cn-mgmt-slot-cr.yaml
kubectl apply -f pan-cn-mgmt-secret.yaml
kubectl apply -f pan-cn-mgmt.yaml


# Create NGFW Pods
# ----------------------------------------------------------------
sleep 2
kubectl apply -f pan-cn-ngfw-configmap.yaml
kubectl apply -f pan-cn-ngfw.yaml

# Create allow-all policy
kubectl apply -f Z_allow_all_policy.yaml 

# Check MGMT Pod status (5-6 minutes to appear in Panorama)
sleep 2
kubectl get pods -l app=pan-mgmt -n kube-system

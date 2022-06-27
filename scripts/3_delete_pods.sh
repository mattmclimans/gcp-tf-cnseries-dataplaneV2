kubectl delete -f pan-cni-configmap.yaml
kubectl delete -f pan-cn-ngfw-svc.yaml
kubectl delete -f pan-cni.yaml
kubectl delete -f pan-cn-mgmt-configmap.yaml
kubectl delete -f pan-cn-mgmt-slot-crd.yaml
kubectl delete -f pan-cn-mgmt-slot-cr.yaml
kubectl delete -f pan-cn-mgmt-secret.yaml
kubectl delete -f pan-cn-mgmt.yaml

kubectl delete -f pan-cn-ngfw-configmap.yaml
kubectl delete -f pan-cn-ngfw.yaml



# Delete Storage
# ----------------------------------------------------------------
kubectl -n kube-system delete pvc -l appname=pan-mgmt-sts
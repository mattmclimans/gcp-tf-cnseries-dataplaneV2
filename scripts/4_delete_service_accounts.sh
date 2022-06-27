# Delete Service Accounts
# ----------------------------------------------------------------
kubectl delete -f plugin-serviceaccount.yaml
kubectl delete -f pan-mgmt-serviceaccount.yaml
kubectl delete -f pan-cni-serviceaccount.yaml
rm pan-plugin-user.json
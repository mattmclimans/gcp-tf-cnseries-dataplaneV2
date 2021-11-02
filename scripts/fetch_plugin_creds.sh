kubectl apply -f scripts/pan-plugin-user-tf.yaml
MY_TOKEN=`kubectl get serviceaccounts pan-plugin-user-tf -n kube-system -o jsonpath='{.secrets[0].name}'`
kubectl get secret $MY_TOKEN -n kube-system -o json > PANORAMA_PLUGIN_CREDS.json
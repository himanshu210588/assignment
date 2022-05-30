#!/bin/sh
if [[ "$1" == "" ]]; then
   echo "specify namespace"
   exit 1
fi
cat ./serviceaccount.yaml | sed "s/@NAMESPACE@/$1/g" > ./sa.tmp
kubectl apply -f ./sa.tmp
SECRET=$(kubectl get serviceAccount sa-azure-devops-amd -n $1 -o=jsonpath={.secrets[*].name})
echo "$SECRET"
FINALSECRET=$(echo $SECRET | awk '{ print $2 }')
echo "$FINALSECRET"
kubectl get secret $FINALSECRET -n $1 -o json
echo "server: "
kubectl config view --minify -o jsonpath={.clusters[0].cluster.server}
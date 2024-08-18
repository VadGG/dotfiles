#!/usr/bin/env zsh

if docker info > /dev/null 2>&1; then
  echo "Docker is running.."
  export ARGOCD_CONTEXT=kind-kind
  export ARGOCD_USERNAME=admin
  export ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo)
  export ARGOCD_SERVER="argo-127-0-0-1.nip.io"
  alias argoin="argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --grpc-web"
  # alias argoin="argocd login localhost:8080 --insecure --username admin --password $(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
  export KUBE_EDITOR=hx
 
fi


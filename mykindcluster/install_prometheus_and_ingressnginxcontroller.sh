echo "deploying prometheus.."
helm upgrade --install prometheusgrafana kube-prometheus-stack \
  --repo https://prometheus-community.github.io/helm-charts \
  --namespace observability \
  --create-namespace \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

echo "creating ingress-nginx ns"
kubectl create ns ingress-nginx

echo "creating default-ssl-certificate for ingress-controller"
kubectl -n ingress-nginx create secret tls wildcard.dev.enjoydevops.com \
  --cert ~me/mystuff/myletsencrypt/wildcard.dev.enjoydevops.com/certificate.crt \
  --key ~me/mystuff/myletsencrypt/wildcard.dev.enjoydevops.com/private.key

echo "deploying ingress-nginx controller.."
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.metrics.enabled=true \
  --set controller.metrics.serviceMonitor.enabled=true \
  --set controller.metrics.serviceMonitor.additionalLabels.release="prometheusgrafana" \
  --set controller.service.externalTrafficPolicy=Local \
  --set controller.extraArgs.default-ssl-certificate=ingress-nginx/wildcard.dev.enjoydevops.com

echo "creating ingress for grafana.."
ingressnginxPodName=$(kubectl -n ingress-nginx get po | grep -i ingress-nginx-controller | cut -f1 -d" ")
kubectl -n ingress-nginx wait --for=condition=Ready pod/$ingressnginxPodName --timeout 180s
kubectl -n observability create ingress grafana \
  --class nginx \
  --rule grafana.dev.enjoydevops.com/"*"=prometheusgrafana:80,tls

kubectl create ns httpbun
kubectl -n httpbun create deploy httpbun --image ghcr.io/sharat87/httpbun --port 80
kubectl -n httpbun expose deploy httpbun --port 80
kubectl -n httpbun create ingress httpbun --class nginx --rule httpbun.dev.enjoydevops.com/"*"=httpbun:80,tls

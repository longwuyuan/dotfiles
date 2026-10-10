kubectl create ns python-crud-api
kubectl -n python-crud-api create secret tls wildcard.dev.enjoydevops.com --cert ~me/mystuff/myletsencrypt/dev.enjoydevops.com/fullchain1.pem --key ~me/mystuff/myletsencrypt/dev.enjoydevops.com/privkey1.pem
kubectl -n python-crud-api create ing pycrudapi --class nginx --rule pycrudapi.dev.enjoydevops.com/"*"=pycrudapi:80,tls=wildcard.dev.enjoydevops.com
argocd app create pycrudapi --repo https://github.com/longwuyuan/python-crud-api --path install --dest-name in-cluster --dest-namespace python-crud-api
argocd app sync pycrudapi

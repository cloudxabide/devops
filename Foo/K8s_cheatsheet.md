# Kubernetes Cheatsheet


## Kubectl
Status: work in progress  
Goal: figure out how to manage several clusters from my admin host  

```
KUBE_HOME=${HOME}/.kube

mkdir ${KUBE_HOME}/${K8S_CLUSTER_NAME}
# cp kubeconfig to ${KUBE_HOME}/${K8S_CLUSTER_NAME}

export KUBECONFIG=$KUBE_HOME/config
export KUBECONFIG=$KUBECONFIG:~/.kube/kubeconfig-1:~/.kube/kubeconfig-2
```



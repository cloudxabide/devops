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

### KUBECONFIG

```
kubectl config get-contexts
kubectl config delete-cluster 

```

## EKS Foo

```
ENDPOINT_IP=169.254.169.254
kubectl run -it debug --image amazon/aws-cli --command bash
TOKEN=`curl -X PUT "http://${ENDPOINT_IP}/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://${ENDPOINT_IP}/
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://${ENDPOINT_IP}/latest/meta-data
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://${ENDPOINT_IP}/latest/dynamic/instance-identity/document
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://${ENDPOINT_IP}/latest/meta-data/iam/security-credentials/

curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://${ENDPOINT_IP}/latest/meta-data/ami-id ami-0abcdef1234567890                    

```

## Managing my KUBECONFIG
- Status:  Work In Progress.  I am still exploring experimenting.
Following guidance from here: https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/

I add the following to my ~/.bashrc.d/common 
```
KUBECONFIG=${HOME}/.kube/config
```

To initially create the config, I run the following (and this does not work)
```
cat $(find ~/eksa/*/latest/ -name "*kubeconfig") > $KUBECONFIG
```

## To add the configs to the global kube directory (more of a one-time thing)
```
find ~/eksa/*/latest/ -name "*kubeconfig" -exec cp {} ${HOME}/.kube/ \;
```

## probably add this to my bashrc
```
unset KUBECONFIG; export KUBECONFIG=${HOME}/.kube/config
```
## Update Global KUBECONFIG
This will collect the "latest" kubeconfig (based on my own directory structure)
```
update_kubeconfig() {
unset KUBECONFIG; export KUBECONFIG=${HOME}/.kube/config
cat /dev/null > $KUBECONFIG
for CONFIG in $(find ${HOME}/.kube/ -name "*kubeconfig"); do export KUBECONFIG=$KUBECONFIG:$CONFIG; done
kubectl config view --flatten > ${HOME}/.kube/config
unset KUBECONFIG; export KUBECONFIG=${HOME}/.kube/config
}

```

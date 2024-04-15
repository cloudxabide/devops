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

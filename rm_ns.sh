# 指定需要删除的命名空间
NAMESPACE='argocd-new'

RANCHER_SERVER_URL=$( kubectl config view -o json|jq -r .clusters[0].cluster.server )
CLUSTER_TOKEN=$( kubectl config view -o json|jq -r .users[0].user.token )

# 获取删除 finalizers 后的命名空间 json 配置
kubectl get ns ${NAMESPACE} -o json| \
  jq 'del(.spec.finalizers[])'| \
  jq 'del(.metadata.finalizers)' > ${NAMESPACE}.json

curl -k \
-H "Content-Type: application/json" \
-H "Authorization: Bearer ${CLUSTER_TOKEN}" \
-X PUT \
--data-binary @${NAMESPACE}.json \
${RANCHER_SERVER_URL}/api/v1/namespaces/${NAMESPACE}/finalize

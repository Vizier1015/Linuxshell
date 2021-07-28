NAMESPACE='' # 指定需要删除的命名空间
KUBE_CONFIG='' # 指定 K8S 配置文件

K8S_API_URL=$( kubectl --kubeconfig=${KUBE_CONFIG} config view --raw -o json|jq -r '.clusters[0].cluster.server' )

# 注意：如果 config 中证书是以文件保存，此处命令
kubectl --kubeconfig=${KUBE_CONFIG} config view --raw -o json| \
  jq -r '.users[0].user."client-certificate-data"'| \
  tr -d '"'|base64 --decode > /tmp/client_cert.pem

kubectl --kubeconfig=${KUBE_CONFIG} config view --raw -o json| \
  jq -r '.users[0].user."client-key-data"'| \
  tr -d '"'|base64 --decode > /tmp/client_key.pem

kubectl --kubeconfig=${KUBE_CONFIG} config view --raw -o json| \
  jq -r '.clusters[0].cluster."certificate-authority-data"'| \
  tr -d '"'|base64 --decode > /tmp/client_ca.pem

# 获取删除 finalizers 后的命名空间 json 配置
kubectl --kubeconfig=${KUBE_CONFIG} get ns ${NAMESPACE} -ojson| \
  jq 'del(.spec.finalizers[])'| \
  jq 'del(.metadata.finalizers)' > ${NAMESPACE}.json

curl -k \
--cert /tmp/client_cert.pem \
--key /tmp/client_key.pem \
--cacert /tmp/client_ca.pem \
-H "Content-Type: application/json" \
-X PUT \
--data-binary @${NAMESPACE}.json \
${K8S_API_URL}/api/v1/namespaces/${NAMESPACE}/finalize

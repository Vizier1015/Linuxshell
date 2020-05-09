k8s_exec_shell_1 = "kubectl get pod -o wide | grep shinan |grep dev | grep -v python | awk '{print $1}'|awk NR==1"
k8s_exec_shell_2 = "kubectl get pod -o wide | grep shinan |grep dev | grep -v python | awk '{print $1}'|awk NR==2"
k8s_exec_shell_3 = "kubectl get pod -o wide | grep shinan |grep dev | grep -v python | awk '{print $1}'|awk NR==3"
k8s_exec_shell_4 = "kubectl get pod -o wide | grep shinan |grep dev | grep -v python | awk '{print $1}'|awk NR==4"

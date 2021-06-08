docker run --rm -t \
	-v /home2/grant/workspace/kubeup/kubeconfig-k8s-1.conf:/tmp/kubeconfig \
	-e KUBECONFIG=/tmp/kubeconfig \
	docker.portworx.dev/portworx/k8s-e2e-test:latest

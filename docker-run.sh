docker run --rm -t \
	-v /home2/grant/workspace/kubeup/kubeconfig.conf:/tmp/kubeconfig \
	-e KUBECONFIG=/tmp/kubeconfig \
	docker.portworx.dev/portworx/k8s-e2e-test:latest

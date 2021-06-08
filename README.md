# K8s e2e test

## Overview

This repo houses the nessesary scripts and configurations to run the k8s e2e tests against the Portworx CSI Driver.

## Pre-reqs
1. Install k8s cluster via [kubeup](https://github.com/lpabon/kubeup) or similar method
2. Install [Portworx CSI Driver](https://docs.portworx.com/portworx-install-with-kubernetes/storage-operations/csi/)

## Running tests
```
docker run --rm -t \
	-v <KUBECONFIG_LOCAL_PATH>:/tmp/kubeconfig \
	-e KUBECONFIG=/tmp/kubeconfig \
	docker.io/openstorage/k8s-e2e-test:master
```

## Building 
* Every commit is built and pushed to `docker.io/openstorage/k8s-e2e-test:master`
* Manual build: `make build`

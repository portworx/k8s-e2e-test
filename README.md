# K8s e2e test

## Overview

This repo houses the nessesary scripts and configurations to run the k8s e2e tests against the Portworx CSI Driver.

## Pre-reqs
1. Install k8s cluster via [kubeup](https://github.com/lpabon/kubeup) or similar method
2. Install [Portworx CSI Driver](https://docs.portworx.com/portworx-install-with-kubernetes/storage-operations/csi/)
3. Set `KUBECONFIG` to be the target test cluster 

## Running tests
```
./run.sh
```

## Configuring tests
See configurable variables in `run.sh` headers.


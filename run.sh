#!/bin/bash

# Harcoded
K8S_E2E_TEST_PATH=$PWD/e2e.test
REPORTS_DIR=reports
LOGS_DIR=/logs
SPECS_DIR=/specs
SKIP_PATTERN="\[Disruptive\]"

# Configurable
K8S_VERSION="${K8S_VERSION:-v1.21.0}"
CONFIG_NAME="${CONFIG_NAME-block}"
INSTALL_SNAPSHOTTING="${INSTALL_SNAPSHOTTING:-false}"

# Dynamic
CONFIG_PATH=config/${CONFIG_NAME}.yaml
RUN_ID=$(date +%s)

set -x
# Download k8s test suite
curl --location https://dl.k8s.io/$K8S_VERSION/kubernetes-test-linux-amd64.tar.gz | \
  tar --strip-components=3 -zxf - kubernetes/test/bin/e2e.test kubernetes/test/bin/ginkgo

# Create folders
mkdir -p $REPORTS_DIR
mkdir -p $LOGS_DIR

# Install snapshotting
if [ "$INSTALL_SNAPSHOTTING" == "true" ]; then
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.1.1/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.1.1/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.1.1/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.1.1/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
  kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/v4.1.1/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
fi

# Create pre-req specs
kubectl apply -f $SPECS_DIR

# Run tests
./ginkgo -v -p -focus=External.Storage \
	-skip=$SKIP_PATTERN ./e2e.test -- \
	-report-dir=$REPORTS_DIR \
	-storage.testdriver=$CONFIG_PATH 

# Cleanup specs
kubectl delete -f $SPECS_DIR

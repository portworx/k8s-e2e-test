# Harcoded
K8S_E2E_TEST_PATH=$PWD/e2e.test
REPORTS_DIR=reports
LOGS_DIR=/logs
SPECS_DIR=/specs
SKIP_PATTERN="\[Serial\]|\[Disruptive\]|\[Feature:|Disruptive|different\s+node"

# Configurable
K8S_VERSION="${K8S_VERSION:-v1.20.6}"
CONFIG_NAME="${CONFIG_NAME-block}"

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

# Create pre-req specs
kubectl apply -f $SPECS_DIR

# Run tests
./ginkgo -v -p -focus=External.Storage \
	-skip=$SKIP_PATTERN ./e2e.test -- \
	-report-dir=$REPORTS_DIR \
	-storage.testdriver=$CONFIG_PATH 

# Harcoded
BASE_DIR=$PWD
K8S_E2E_TEST_PATH=$PWD/e2e.test
REPORTS_DIR=$BASE_DIR/reports
LOGS_DIR=$BASE_DIR/logs
SPECS_DIR=$BASE_DIR/specs
SKIP_PATTERN="\[Serial\]|\[Disruptive\]|\[Feature:|Disruptive|different\s+node"

# Configurable
K8S_VERSION="${K8S_VERSION:-v1.20.6}"
CONFIG_NAME="${CONFIG_NAME-block}"

# Dynamic
CONFIG_PATH=$BASE_DIR/config/${CONFIG_NAME}.yaml
RUN_ID=$(date +%s)

set -x
# Download k8s test suite
if test ! -f "$K8S_E2E_TEST_PATH"; then
  curl --location https://dl.k8s.io/$K8S_VERSION/kubernetes-test-linux-amd64.tar.gz | \
	  tar --strip-components=3 -zxf - kubernetes/test/bin/e2e.test kubernetes/test/bin/ginkgo
fi

# Create folders
mkdir -p $REPORTS_DIR
mkdir -p $LOGS_DIR

# Create pre-req specs
kubectl apply -f $SPECS_DIR

# Run tests
$BASE_DIR/ginkgo -v -p -focus=External.Storage \
	-skip=$SKIP_PATTERN $BASE_DIR/e2e.test -- \
	-test.outputdir="$LOGS_DIR" \
	-report-dir=$REPORTS_DIR \
	-storage.testdriver=$CONFIG_PATH 

# Cleanup specs
kubectl delete -f $SPECS_DIR

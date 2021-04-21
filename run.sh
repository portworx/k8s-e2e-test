# Harcoded
BASE_DIR=$PWD
K8S_ORG_DIR=$GOPATH/src/github.com/kubernetes
K8S_E2E_TEST_DIR=$K8S_ORG_DIR/kubernetes/test/e2e
REPORTS_DIR=$BASE_DIR/reports
LOGS_DIR=$BASE_DIR/logs
SKIP_PATTERN="\[Serial\]|\[Disruptive\]|\[Feature:|Disruptive|different\s+node"

# Configurable
K8S_VERSION="${K8S_VERSION:-v1.20.6}"
CONFIG_NAME="${CONFIG_NAME-block}"

# Dynamic
CONFIG_PATH=$BASE_DIR/config/${CONFIG_NAME}.yaml
RUN_ID=$(date +%s)

set -x
# Clone k8s if it does not exist and clone
if [ ! -d "$K8S_ORG_DIR" ]; then
  mkdir -p $K8S_ORG_DIR
  
  git clone --branch $K8S_VERSION git@github.com:kubernetes/kubernetes.git 
  cd kubernetes
fi
cd $K8S_ORG_DIR/kubernetes
pwd

# Create folders
mkdir -p $REPORTS_DIR
mkdir -p $LOGS_DIR

# Create pre-req specs
kubectl apply -f $SPECS_DIR

# Run tests
cd ~/workspace/go/src/github.com/kubernetes/kubernetes
ginkgo -v -p -focus=External.Storage \
	-skip=$SKIP_PATTERN $K8S_E2E_TEST_DIR -- \
	-test.outputdir="$LOGS_DIR" \
	-report-dir=$REPORTS_DIR \
	-storage.testdriver=$CONFIG_PATH

# Cleanup specs
kubectl delete -f $SPECS_DIR

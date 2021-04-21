BASE_DIR=$PWD
K8S_ORG_DIR=$GOPATH/src/github.com/kubernetes
K8S_E2E_TEST_DIR=$K8S_ORG_DIR/kubernetes/test/e2e
REPORT_DIR=$BASE_DIR/reports
CONFIG_PATH=$BASE_DIR/config/block.yaml
SPECS_DIR=$BASE_DIR/specs

K8S_VERSION="v1.20.6"
SKIP_PATTERN="\[Serial\]|\[Disruptive\]|\[Feature:|Disruptive|different\s+node"

set -x
# Clone k8s if it does not exist and clone
if [ ! -d "$K8S_ORG_DIR" ]; then
  mkdir -p $K8S_ORG_DIR
  
  git clone --branch $K8S_VERSION git@github.com:kubernetes/kubernetes.git 
  cd kubernetes
fi
cd $K8S_ORG_DIR/kubernetes
pwd

# Create pre-req specs
kubectl apply -f $SPECS_DIR

# Run tests
cd ~/workspace/go/src/github.com/kubernetes/kubernetes
ginkgo -p -focus=External.Storage \
	-skip=$SKIP_PATTERN $K8S_E2E_TEST_DIR -- \
	-report-dir=$REPORT_DIR \
	-storage.testdriver=$CONFIG_PATH

# Cleanup specs
kubectl delete -f $SPECS_DIR

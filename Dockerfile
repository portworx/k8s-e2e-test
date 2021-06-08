FROM ubuntu

LABEL name="Portworx K8s e2e test" \
      vendor="portworx.com" \
      version="v1.0.0" \
      release="1" \
      summary="Portworx K8s e2e test" \
      description="This will run a compiled version of the k8s e2e tests with the Portworx CSI Driver"

WORKDIR /

COPY config /config
COPY run.sh /run.sh
COPY specs /specs

RUN apt-get update; apt-get install -y curl  
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

ENTRYPOINT /run.sh

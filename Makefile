# set defaults
DOCKER_HUB_REPO := openstorage
DOCKER_HUB_TEST_IMAGE := k8s-e2e-test
DOCKER_HUB_TEST_TAG := master
TEST_IMG=$(DOCKER_HUB_REPO)/$(DOCKER_HUB_TEST_IMAGE):$(DOCKER_HUB_TEST_TAG)

.DEFAULT_GOAL=all
.PHONY: clean

container:
	sudo docker build --tag $(TEST_IMG) .

deploy:
	docker push $(TEST_IMG)

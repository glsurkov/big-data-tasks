DOCKER_NETWORK = hadoop-network
ENV_FILE = hadoop.env
current_branch := 2.0.0-hadoop3.2.1-java8
TASK ?= task_1
BUILD_TOOL ?= maven
OUTPUT_DIR := tasks/$(TASK)/output

wordcount:
	@echo ">>> Building with $(BUILD_TOOL) for task: $(TASK)"
ifeq ($(BUILD_TOOL),maven)
	cd tasks/$(TASK) && mvn clean package
else ifeq ($(BUILD_TOOL),ant)
	cd tasks/$(TASK) && ant clean jar
else
	$(error Invalid BUILD_TOOL specified: '$(BUILD_TOOL)'. Use 'maven' or 'ant'.)
endif
	# cd tasks/$(TASK) && ant clean jar
	@mkdir -p $(OUTPUT_DIR)
	docker build -t hadoop-wordcount-$(TASK) --build-arg TASK=$(TASK) .
	docker run --rm --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} \
	  -v $(shell pwd)/$(OUTPUT_DIR):/output-local:rw \
	  -v $(shell pwd)/scripts/hdfs-job-runner.sh:/hdfs-job-runner.sh \
	  hadoop-wordcount-$(TASK) \
	  sh /hdfs-job-runner.sh




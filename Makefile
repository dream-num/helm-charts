REGISTRY = univer-acr-registry.cn-shenzhen.cr.aliyuncs.com
NS = helm-charts
BUILD_DIR = build

.PHONY: all
all: prepare universer collaboration-server collaboration-demo worker univer-ssc univer-stack

.PHONY: prepare
prepare:
	# Prepare build dir
	@mkdir -p $(BUILD_DIR)

.PHONY: universer
universer: prepare
	# Build and push universer chart
	@helm package charts/universer -d $(BUILD_DIR)
	@helm push $(BUILD_DIR)/universer-*.tgz oci://$(REGISTRY)/$(NS)

.PHONY: collaboration-server
collaboration-server: prepare
	# Build and push collaboration-server chart
	@helm package charts/collaboration-server -d $(BUILD_DIR)
	@helm push $(BUILD_DIR)/collaboration-server-*.tgz oci://$(REGISTRY)/$(NS)

.PHONY: collaboration-demo
collaboration-demo: prepare
	# Build and push collaboration-demo chart
	@helm package charts/collaboration-demo -d $(BUILD_DIR)
	@helm push $(BUILD_DIR)/collaboration-demo-*.tgz oci://$(REGISTRY)/$(NS)

.PHONY: worker
worker: prepare
	# Build and push worker chart
	@helm package charts/worker -d $(BUILD_DIR)
	@helm push $(BUILD_DIR)/worker-*.tgz oci://$(REGISTRY)/$(NS)

.PHONY: univer-ssc
univer-ssc: prepare
	# Build and push univer-ssc chart
	@helm package charts/univer-ssc -d $(BUILD_DIR)
	@helm push $(BUILD_DIR)/univer-ssc-*.tgz oci://$(REGISTRY)/$(NS)

.PHONY: univer-stack
univer-stack: prepare
	# Build and push univer-stack chart
	@helm dependency update charts/univer-stack --skip-refresh
	@helm package charts/univer-stack -d $(BUILD_DIR)
	@helm push $(BUILD_DIR)/univer-stack-*.tgz oci://$(REGISTRY)/$(NS)

.PHONY: univer-observability
univer-observability: prepare
	# Build and push univer-observability chart
	@helm dependency update charts/univer-stack --skip-refresh
	@helm package charts/univer-observability -d $(BUILD_DIR)
	@helm push $(BUILD_DIR)/univer-observability-*.tgz oci://$(REGISTRY)/$(NS)

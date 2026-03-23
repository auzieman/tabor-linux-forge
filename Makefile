IMAGE_NAME ?= tabor-linux-forge-kernel
KERNEL_PROFILE ?= profiles/kernel/upstream-6.6-lts.env
ARCH ?= powerpc
CROSS_COMPILE ?= powerpc-linux-gnu-
OUT_DIR ?= out/tabor
UID ?= $(shell id -u)
GID ?= $(shell id -g)
COMPOSE ?= UID=$(UID) GID=$(GID) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) KERNEL_PROFILE=$(KERNEL_PROFILE) docker compose
RUN_IN_CONTAINER = $(COMPOSE) run --rm kernel-builder

.PHONY: container fetch patch configure kernel package testbundle shell clean profile

container:
	$(COMPOSE) build kernel-builder

fetch:
	$(RUN_IN_CONTAINER) ./scripts/fetch-linux.sh $(KERNEL_PROFILE)

patch:
	$(RUN_IN_CONTAINER) ./scripts/apply-patches.sh

configure:
	$(RUN_IN_CONTAINER) ./scripts/configure-tabor.sh

kernel:
	$(RUN_IN_CONTAINER) ./scripts/build-kernel.sh

package:
	$(RUN_IN_CONTAINER) ./scripts/package-kernel.sh

testbundle:
	$(RUN_IN_CONTAINER) ./scripts/build-testbundle.sh

shell:
	$(RUN_IN_CONTAINER) bash

profile:
	@echo $(KERNEL_PROFILE)

clean:
	rm -rf $(OUT_DIR) artifacts/tabor

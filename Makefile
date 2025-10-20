.PHONY: all clean

DOCKER_IMAGE ?= aabadie/dotbot:latest
DOCKER_TARGETS ?= all
PACKAGES_DIR_OPT ?=
SEGGER_DIR ?= /opt/segger
BUILD_CONFIG ?= Debug
BUILD_TARGET ?= nrf52840dk
PROJECT_FILE ?= $(BUILD_TARGET).emProject
BOOTLOADER ?= bootloader
QUIET ?= 0
VERBOSE_OPTS ?= -verbose -echo
ifeq ($(QUIET),1)
  VERBOSE_OPTS =
endif

DIRS ?= app lib
SRCS ?= $(foreach dir,$(DIRS),$(shell find $(dir) -name "*.[c|h]"))
CLANG_FORMAT ?= clang-format
CLANG_FORMAT_TYPE ?= file

.PHONY: upgate docker docker-release format check-format

all: upgate

upgate:
	@echo "\e[1mBuilding project $@\e[0m"
	"$(SEGGER_DIR)/bin/emBuild" $(PROJECT_FILE) -project $@ -config $(BUILD_CONFIG) $(PACKAGES_DIR_OPT) -rebuild $(VERBOSE_OPTS)
	@echo "\e[1mDone\e[0m\n"

clean:
	"$(SEGGER_DIR)/bin/emBuild" $(PROJECT_FILE) -config $(BUILD_CONFIG) -clean $(VERBOSE_OPTS)

distclean: clean

format:
	@$(CLANG_FORMAT) -i --style=$(CLANG_FORMAT_TYPE) $(SRCS)

check-format:
	@$(CLANG_FORMAT) --dry-run --Werror --style=$(CLANG_FORMAT_TYPE) $(SRCS)

docker:
	docker run --rm -i \
		-e BUILD_TARGET="$(BUILD_TARGET)" \
		-e BUILD_CONFIG="$(BUILD_CONFIG)" \
		-e PACKAGES_DIR_OPT="-packagesdir $(SEGGER_DIR)/packages" \
		-e PROJECTS="$(PROJECTS)" \
		-e SEGGER_DIR="$(SEGGER_DIR)" \
		-v $(PWD):/dotbot $(DOCKER_IMAGE) \
		make $(DOCKER_TARGETS)

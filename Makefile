.PHONY: build assembly makePkg partialUpdatePsd clean help

PROJECT_NAME := OreUI-For-Everyone-forked
VERSION := 1.0
CACHE_DIR := .cache
BUILD_DIR := ./build
ASSETS_DIR := ./assets
CACHE_ASSETS := $(CACHE_DIR)/assets
.DEFAULT_GOAL := build

build: assembly makePkg clean
	@echo "===== Build - $(PROJECT_NAME) ====="
	@echo "BUILD SUCCEED!"

assembly: $(CACHE_DIR)
	@mkdir -p $(CACHE_ASSETS)
	@rsync -av $(ASSETS_DIR)/ $(CACHE_ASSETS)/ --exclude='*.psd'
	@echo "Converting PSD files..."
	@find $(ASSETS_DIR) -name "*.psd" -exec sh -c 'psdcvt "$$1" "$(CACHE_ASSETS)/"' _ {} \;
	@cp pack.png $(CACHE_DIR)/pack.png
	@cp pack.mcmeta $(CACHE_DIR)/pack.mcmeta
	@cp README.md $(CACHE_DIR)/README.md
	@cp LICENSE $(CACHE_DIR)/LICENSE
	@cp contributor.csv $(CACHE_DIR)/contributor.csv
	@echo "Assembly complete!"

makePkg:
	@mkdir -p $(BUILD_DIR)
	@cd $(CACHE_DIR) && zip -r ../$(BUILD_DIR)/$(PROJECT_NAME)_$(VERSION).zip . -q
	@echo "Package created: $(BUILD_DIR)/$(PROJECT_NAME)_$(VERSION).zip"

partialUpdatePsd:
	@psdcvt $(ASSETS_DIR)/ $(CACHE_ASSETS)/
	@echo "PSD update complete!"

$(CACHE_DIR):
	@mkdir -p $(CACHE_DIR)

clean:
	@rm -rf $(CACHE_DIR)
	@echo "Cleaned!"

help:
	@echo "OreUI-For-Everyone Build Targets:"
	@echo "  make build              - Build the project (default)"
	@echo "  make clean              - Clean all outputs"
	@echo "  make help               - Show this help"

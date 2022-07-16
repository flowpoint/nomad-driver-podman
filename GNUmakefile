SHELL = bash

GOPATH := $(shell go env GOPATH | cut -d: -f1)

default: help

HELP_FORMAT="    \033[36m%-25s\033[0m %s\n"
.PHONY: help
help: ## Display this usage information
	@echo "Valid targets:"
	@grep -E '^[^ ]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; \
			{printf $(HELP_FORMAT), $$1, $$2}'
	@echo ""

.PHONY: changelogfmt
changelogfmt: ## Format changelog GitHub links
	@echo "--> Making [GH-xxxx] references clickable..."
	@sed -E 's|([^\[])\[GH-([0-9]+)\]|\1[[GH-\2](https://github.com/hashicorp/nomad-driver-podman/issues/\2)]|g' CHANGELOG.md > changelog.tmp && mv changelog.tmp CHANGELOG.md

.PHONY: check
check: deps hclfmt ## Lint the source code
	@echo "==> Linting source code ..."
	@$(GOPATH)/bin/golangci-lint run
	@echo "==> vetting hc-log statements"
	@$(GOPATH)/bin/hclogvet $(CURDIR)

.PHONY: hclfmt
hclfmt: ## Format HCL files with hclfmt
	@echo "--> Formatting HCL"
	@find . -name '.git' -prune \
	        -o \( -name '*.nomad' -o -name '*.hcl' -o -name '*.tf' \) \
	      -print0 | xargs -0 hclfmt -w
	@if (git status -s | grep -q -e '\.hcl$$' -e '\.nomad$$' -e '\.tf$$'); then echo The following HCL files are out of sync; git status -s | grep -e '\.hcl$$' -e '\.nomad$$' -e '\.tf$$'; exit 1; fi

.PHONY: deps
deps: ## Install build dependencies
	@echo "==> Installing build dependencies ..."
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.45.2
	go install github.com/hashicorp/go-hclog/hclogvet@main
	go install gotest.tools/gotestsum@v1.8.0
	go install github.com/hashicorp/hcl/v2/cmd/hclfmt@d0c4fa8b0bbc2e4eeccd1ed2a32c2089ed8c5cf1

.PHONY: clean
clean: ## Cleanup previous build
	@echo "==> Cleanup previous build"
	rm -rf ./pkg
	rm -rf .release/linux/package/opt/nomad/plugins/*

pkg/%/nomad-driver-podman: GO_OUT ?= $@
pkg/%/nomad-driver-podman: ## Build the nomad-driver-podman plugin for GOOS_GOARCH, e.g. pkg/linux_amd64/nomad-driver-podman
	@echo "==> Building $@ with tags $(GO_TAGS)..."
	CGO_ENABLED=0 \
		GOOS=$(firstword $(subst _, ,$*)) \
		GOARCH=$(lastword $(subst _, ,$*)) \
		go build -trimpath -o $(GO_OUT)
	mkdir -p .release/linux/package/opt/nomad/plugins/
	cp -v $(CURDIR)/$@ $(CURDIR)/.release/linux/package/opt/nomad/plugins/nomad-driver-podman

##-$(firstword $(subst _, ,$*)).$(lastword $(subst _, ,$*))

.PRECIOUS: pkg/%/nomad-driver-podman
pkg/%.zip: pkg/%/nomad-driver-podman ## Build and zip the nomad-driver-podman plugin for GOOS_GOARCH, e.g. pkg/linux_amd64.zip
	@echo "==> Packaging for $@..."
	zip -j $@ $(dir $<)*

.PHONY: dev
dev: check clean build/nomad-driver-podman ## Build the nomad-driver-podman plugin

build/nomad-driver-podman:
	@echo "==> Building driver plugin ..."
	mkdir -p build
	go build -o build/nomad-driver-podman .

.PHONY: test
test: ## Run unit tests
	@echo "==> Running unit tests ..."
	go test -v -race ./...

.PHONY: version
version:
ifneq (,$(wildcard version/version_ent.go))
	@$(CURDIR)/scripts/version.sh version/version.go version/version_ent.go
else
	@$(CURDIR)/scripts/version.sh version/version.go version/version.go
endif

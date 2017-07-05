MAKEFLAGS     += --no-builtin-rules --no-builtin-variables --no-print-directory --warn-undefined-variables
.DEFAULT_GOAL := help

ifndef CONCOURSE_ALIAS
$(error Set CONCOURSE_ALIAS to the alias of the Concourse server you wish to use)
endif
ifndef EB_SECRETS_FILE
$(error Set EB_SECRETS_FILE to the path of the YaML file containing EB Dockerhub secrets)
endif

SHELL    := /usr/bin/env bash -uo pipefail
FLY      ?= \fly -t $(CONCOURSE_ALIAS)
PIPELINE ?= pcfops-docker
CONFIG   ?= ci/pipeline.yml

ci-pipeline: ## Update the CI pipeline from local config
	$(FLY) set-pipeline -p $(PIPELINE) -c $(CONFIG) --load-vars-from=$(EB_SECRETS_FILE)

ci-check-config: ## Sense-check the local config
	$(FLY) validate-pipeline --strict --config=$(CONFIG)

help: ## This help listing
	@awk -F":.*## " '$$2&&$$1~/^[a-zA-Z_%-]+/{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

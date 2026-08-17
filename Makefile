# Oju day-to-day commands.
# Contracts run on Scarb + Starknet Foundry (see .tool-versions); frontend is an npm workspace.
# Deploy/verify targets expect an account profile in contracts/snfoundry.toml (set up in M5).

.DEFAULT_GOAL := help

NETWORK ?= sepolia
CONTRACT ?= HealthCheck
CLASS_HASH ?=
ADDRESS ?=

## ---------- Setup ----------

.PHONY: install
install: ## Install all JS dependencies (npm workspaces)
	npm install

## ---------- Contracts ----------

.PHONY: build
build: ## Build the Cairo contracts
	cd contracts && scarb build

.PHONY: test
test: ## Run the contract test suite (snforge)
	cd contracts && snforge test

.PHONY: fmt
fmt: ## Format contracts and repo docs/config
	cd contracts && scarb fmt
	npm run format

.PHONY: fmt-check
fmt-check: ## Check formatting without writing (CI parity)
	cd contracts && scarb fmt --check
	npm run format:check

## ---------- Frontend ----------

.PHONY: dev
dev: ## Run the frontend dev server
	npm run dev -w @oju/frontend

.PHONY: web-build
web-build: ## Production-build the frontend
	npm run build:frontend

.PHONY: lint
lint: ## Lint the frontend and check contract formatting
	npm run lint:frontend
	cd contracts && scarb fmt --check

.PHONY: typecheck
typecheck: ## Typecheck the frontend
	npm run typecheck:frontend

## ---------- Quality gate ----------

.PHONY: ci
ci: build test web-build lint typecheck fmt-check ## Run everything CI runs

## ---------- Deploy (needs contracts/snfoundry.toml account profile) ----------

.PHONY: declare
declare: ## Declare a contract class: make declare CONTRACT=PariMarket NETWORK=mainnet
	cd contracts && sncast declare --contract-name $(CONTRACT) --network $(NETWORK)

.PHONY: deploy
deploy: ## Deploy a declared class: make deploy CLASS_HASH=0x... NETWORK=mainnet
	cd contracts && sncast deploy --class-hash $(CLASS_HASH) --network $(NETWORK)

.PHONY: verify
verify: ## Verify source on the explorer: make verify ADDRESS=0x... CONTRACT=PariMarket NETWORK=mainnet
	cd contracts && sncast verify --contract-address $(ADDRESS) --contract-name $(CONTRACT) --verifier voyager --network $(NETWORK)

## ---------- Help ----------

.PHONY: help
help: ## List available commands
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

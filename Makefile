-include .env

.PHONY: all test build compile fuzz clean deploy fund help install snapshot format anvil smt coverage

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

install :; forge install foundry-rs/forge-std --no-commit && forge install Arachnid/solidity-stringutils --no-commit && forge install openzeppelin/openzeppelin-contracts@v4.9.0 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

compile:; npx hardhat compile

analyze:; slither .

smt :; FOUNDRY_PROFILE=smt forge build

test :; forge test --no-match-contract Invariants -v

fuzz :; forge test --match-contract Invariants -v

# dependencies: brew install lcov &&  brew install genhtml
# https://www.rareskills.io/post/foundry-forge-coverage
coverage :; forge coverage --report lcov && genhtml lcov.info --branch-coverage --output-dir coverage

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

deploy:
	@forge script DeployDiamond $(NETWORK_ARGS)



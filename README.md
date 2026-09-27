# Decentralized Crowdfunding Platform (Foundry & Ethers.js)

## Overview
This repository contains a full-stack Web3 crowdfunding application built to demonstrate advanced smart contract architecture, multi-chain deployment strategies, and frontend wallet integration. The project enforces a minimum USD funding threshold by programmatically interacting with decentralized oracle networks.

## Technical Stack
* **Smart Contracts:** Solidity (^0.8.34)
* **Development & Testing Framework:** Foundry (Forge, Anvil, Cast)
* **Decentralized Oracles:** Chainlink Data Feeds
* **Frontend:** HTML, Vanilla JavaScript, Ethers.js (v6)
* **Wallet Integration:** MetaMask (`window.ethereum`)

## Core Architecture & Features

### 1. Chainlink Oracle Integration
* **Dynamic Price Conversion:** Integrates `AggregatorV3Interface` to fetch real-time ETH/USD pricing data, ensuring all incoming transactions meet a strict `MINIMUM_USD` threshold.
* **Math Libraries:** Utilizes custom Solidity libraries to handle floating-point math and decimal conversions securely within the EVM.

### 2. Multi-Chain Deployment Strategy
* **HelperConfig Pattern:** Implements a dynamic configuration script that automatically detects the active `block.chainid`.
* **Local Mocking:** Automatically deploys Mock V3 Aggregator contracts when operating on a local Anvil node, while dynamically routing to live Chainlink addresses when deployed to Sepolia or Mainnet.

### 3. Advanced Test Suite (Forge)
* **Mainnet Forking:** Validates external oracle calls by spinning up local forks of live networks using `forge test --fork-url`.
* **State Manipulation:** Employs Foundry cheatcodes (`vm.prank`, `vm.deal`, `vm.expectRevert`) to simulate multi-user funding scenarios, ownership access controls, and failure states.

### 4. Gas Optimization
* **Storage Efficiency:** Uses `constant` and `immutable` keywords for state variables to drastically reduce deployment and execution costs.
* **Custom Errors:** Replaces standard `require` strings with custom error types (e.g., `FundMe__NotOwner()`) to minimize bytecode size and save user gas.

### 5. Frontend UI Integration
* **Browser Provider:** Uses `ethers.BrowserProvider` to detect injected Web3 wallets (MetaMask) via `window.ethereum`.
* **State Execution:** Allows users to connect their wallet, view the current contract balance, fund the contract, and trigger the owner-only withdrawal function directly from the browser.

## Quick Start
*The following instructions are for developers looking to clone and run this project locally.*

**1. Clone and Install Dependencies**
```bash
git clone [https://github.com/Yuvi8990/foundry-fund-me.git](https://github.com/Yuvi8990/foundry-fund-me.git)
cd foundry-fund-me
forge install
```

**2. Compile the Contracts**
```bash
forge build
```

**3. Run the Test Suite**
```bash
forge test
```

**4. Test UI Locally**
Spin up a local Anvil node, deploy the contract using the included Forge scripts, and open `index.html` via a local live server to interact with the frontend.
```bash
anvil
forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --broadcast
```

## Security & Access Control
* **Owner Modifiers:** Strict access control ensures only the deployer address can trigger the `withdraw()` function, resetting the funder mappings and safely transferring the balance.

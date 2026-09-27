# 📦 Decentralized Crowdfunding Smart Contract (Foundry)

## 📖 Overview
This repository contains a Web3 crowdfunding smart contract architecture built to demonstrate advanced EVM mechanics and multi-chain deployment strategies. The project enforces a minimum USD funding threshold by programmatically interacting with decentralized oracle networks.

## 🛠 Technical Stack
* **Smart Contracts:** Solidity (^0.8.34)
* **Development & Testing Framework:** Foundry (Forge, Anvil, Cast)
* **Decentralized Oracles:** Chainlink Data Feeds

## ⚙️ Core Architecture & Features

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

## 🚀 Quick Start
*The following instructions are for developers looking to clone and run this project locally.*

**1. Clone and Install Dependencies**
```bash
git clone https://github.com/Yuvi8990/Foundry-Fund-Me.git
cd Foundry-Fund-Me
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

**4. Local Deployment (Anvil)**
Spin up a local Anvil node and deploy the contract using the included Forge scripts.
```bash
anvil
forge script script/DeployFundMe.s.sol --rpc-url http://localhost:8545 --broadcast
```
### 💻 Interacting with the Contract

Once deployed locally, you can use `cast` to interact with the contract.

**1. Fund the Contract**
Send 0.1 ETH to the contract (ensure you replace the contract address with your deployed address):
```bash
cast send <DEPLOYED_CONTRACT_ADDRESS> "fund()" --value 0.1ether --rpc-url http://localhost:8545 --private-key <YOUR_PRIVATE_KEY>
```

**2. Check the Contract Balance**
```bash
cast balance <DEPLOYED_CONTRACT_ADDRESS> --rpc-url http://localhost:8545
```

**3. Withdraw Funds (Owner Only)**
```bash
cast send <DEPLOYED_CONTRACT_ADDRESS> "withdraw()" --rpc-url http://localhost:8545 --private-key <YOUR_PRIVATE_KEY>
```
## 🛡️ Security & Access Control
* **Owner Modifiers:** Strict access control ensures only the deployer address can trigger the `withdraw()` function, resetting the funder mappings and safely transferring the balance.
  
## ⚖️ License
This project is open-source and available under the **MIT License**.
